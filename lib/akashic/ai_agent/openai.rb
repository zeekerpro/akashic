require 'openai'
require 'stringio'
require 'tty-markdown'

module Akashic
  class AiAgent
    # OpenAI chat implementation for Akashic AI Agent
    class Openai
      # Default configuration for OpenAI chat
      DEFAULT_CONFIG = {
        openai: {
          model: "gpt-4o-mini",
          temperature: 0.7,
          access_token: nil,
          organization_id: nil,
          url_base: "https://api.openai.com/",
          log_errors: true,
          request_timeout: 240
        },
        max_history: 10,
        typing_speed: 0.001
      }.freeze

      # Initialize OpenAI chat agent
      # @param config [Hash] Configuration options to override defaults
      def initialize
        @config = DEFAULT_CONFIG.deep_merge(Akashic.config)
        validate_config
        setup_openai_client
        @conversation_history = []
        @in_code_block = false
        @render_buffer = ""
        # Flag indicating whether we're waiting for the first chunk of streaming response
        # Controls when to stop the spinner and display the "Akashic: " prefix
        @waiting_for_first_chunk = true
      end

      # Start an interactive chat session
      # @param message [String, nil] Initial message to start the conversation
      def session(message = nil)
        chat(message) if message

        loop do
          message = get_user_input
          break if should_exit?(message)
          next if message.nil? || message.empty?

          chat(message)
        end
      end

      # Process a chat message and get AI response
      # @param message [String] User message
      def chat(message)
        return if message.nil? || message.empty?

        @spinner = create_spinner
        @spinner.auto_spin

        begin
          update_conversation_history(message, "user")
          content = fetch_ai_response
          update_conversation_history(content, "assistant")
          puts "\n"  # Add a newline to separate conversations
        rescue OpenAI::Error => e
          handle_error(@spinner, "OpenAI Error: #{e.message}")
        rescue StandardError => e
          handle_error(@spinner, "Unexpected error: #{e.message}")
        ensure
          # Reset the flag for the next conversation
          @waiting_for_first_chunk = true
        end
      end

      private

      # Set up OpenAI client with configuration
      def setup_openai_client
        OpenAI.configure do |config|
          @config.dig(:openai).each_pair do |key, value|
            config.send("#{key}=", value) if config.respond_to?("#{key}=") && value
          end
        end
        @client = OpenAI::Client.new
      end

      # Validate required OpenAI configuration
      # @raise [ConfigurationError] if required configuration is missing
      def validate_config
        required_keys = [:access_token]
        missing_keys = required_keys.select { |key| @config.dig(:openai, key).nil? }
        
        unless missing_keys.empty?
          raise ConfigurationError, "Missing required OpenAI configuration: #{missing_keys.join(', ')}"
        end
      end

      # Fetch AI response with streaming
      # @return [String] Complete response content
      def fetch_ai_response
        content = StringIO.new
        @render_buffer = ""
        
        response = @client.chat(
          parameters: {
            model: @config.dig(:openai, :model),
            messages: @conversation_history,
            temperature: @config.dig(:openai, :temperature),
            stream: Proc.new { |chunk| process_chunk(chunk) }
          }
        )
        
        # Ensure the last buffer content is rendered
        render_content(@render_buffer) if @render_buffer.size > 0
        content.string
      end

      # Process streaming chunks
      # @param chunk [Hash] Response chunk from OpenAI API
      def process_chunk(chunk)
        return unless chunk.key?("choices") && chunk["choices"].first.key?("delta")
        
        content = chunk["choices"].first["delta"]["content"]
        return if content.nil? || content.empty?
        
        if @waiting_for_first_chunk
          @waiting_for_first_chunk = false
          @spinner.stop
          print "Akashic: "
        end

        if content.include?("```")
          @in_code_block = !@in_code_block
          @render_buffer << content
          if !@in_code_block  # End of code block
            render_content(@render_buffer)
            @render_buffer.clear
          end
        elsif @in_code_block
          @render_buffer << content
        else
          @render_buffer << content
          if content.include?("\n")
            render_content(@render_buffer)
            @render_buffer.clear
          end
        end
      end

      # Render content with typing effect
      # @param content [String] Content to render
      def render_content(content)
        return if content.empty?
        
        rendered = TTY::Markdown.parse(content, colors: true)
        rendered.each_char do |char|
          print char
          sleep(@config[:typing_speed])
        end
        $stdout.flush
      end

      # Update conversation history with new message
      # @param content [String] Message content
      # @param role [String] Message role (user/assistant)
      def update_conversation_history(content, role)
        @conversation_history << { role: role, content: content }
        # Keep history within limits
        @conversation_history = @conversation_history.last(@config[:max_history]) if @conversation_history.length > @config[:max_history]
      end

      # Get user input with support for multiline input
      # @return [String, nil] User input or nil if empty
      def get_user_input
        message = Akashic.prompt.multiline(
          "You: ",
          help: '(Press Command+Enter or Ctrl+D to send)',
          interrupt: :exit
        )
        return nil if message.nil? || message.empty?
        
        message.join("\n").strip
      end

      # Check if user wants to exit
      # @param message [String] User message
      # @return [Boolean] True if user wants to exit
      def should_exit?(message)
        message&.strip&.downcase == "exit"
      end

      # Handle errors during chat
      # @param spinner [TTY::Spinner] Current spinner instance
      # @param message [String] Error message
      def handle_error(spinner, message)
        spinner.error(message)
      end

      # Create a spinner for loading animation
      def create_spinner
        TTY::Spinner.new(
          "Akashic: [:spinner] Thinking...",
          format: :dots_8,
          output: $stdout,
          clear: true,
          hide_cursor: true
        )
      end
    end
  end
end
