require 'openai'
require 'stringio'

module Akashic
  class AiAgent
    # OpenAI chat implementation for Akashic AI Agent
    class Openai
      # Configuration for OpenAI chat
      DEFAULT_CONFIG = {
        openai: {
          model: "gpt-4o-mini",
          url_base: "https://api.openai.com/",
          log_errors: true,
          request_timeout: 240
        },
        max_history: 20,
        typing_speed: 0.005
      }.freeze

      # Initialize OpenAI chat agent
      # @param config [Hash] Configuration options to override defaults
      def initialize()
        @config = DEFAULT_CONFIG.deep_merge(Akashic.config)
        validate_config
        setup_openai_client
        @messages = []
      end

      # Start an interactive chat session
      # @param message [String, nil] Initial message to start the conversation
      def session(message = nil)
        loop do
          if message.present?
            break if should_exit?(message)
            display_user_message(message)
          else
            message = get_user_input
            break if should_exit?(message)
            next if message.blank?
          end

          chat(message)
          message = nil
        end
      end

      private

      def setup_openai_client
        OpenAI.configure do |config|
          @config.dig(:openai).each_pair do |key, value|
            config.send("#{key}=", value) if config.respond_to?("#{key}=") && value.present?
          end
        end
        @client = OpenAI::Client.new
      end

      # Validates OpenAI specific configuration
      # @raise [ConfigurationError] if required OpenAI configuration is missing
      def validate_config
        required_keys = [:access_token]
        missing_keys = required_keys.select { |key| @config.dig(:openai, key).nil? }

        if missing_keys.any?
          raise ConfigurationError, "Missing required OpenAI configuration: #{missing_keys.join(', ')}"
        end
      end

      def chat(message)
        spinner = create_spinner
        spinner.auto_spin

        begin
          update_message_history(message, "user")
          content = fetch_ai_response
          update_message_history(content, "assistant")

          spinner.stop
          display_ai_response(content)
        rescue OpenAI::Error => e
          handle_error(spinner, "OpenAI Error: #{e.message}")
        rescue StandardError => e
          handle_error(spinner, "Unexpected error: #{e.message}")
        end
      end

      def create_spinner
        TTY::Spinner.new(
          "Akashic: [:spinner] Thinking...",
          format: :dots_8,
          output: $stdout,
          clear: true
        )
      end

      def fetch_ai_response
        response = @client.chat(
          parameters: {
            model: @config.dig(:openai, :model),
            messages: @messages,
            temperature: @config.dig(:openai, :temperature)
          }
        )
        response.dig("choices", 0, "message", "content")
      end

      def update_message_history(content, role)
        @messages << { role: role, content: content }
        # Keep history within limits
        @messages = @messages.last(@config[:max_history]) if @messages.length > @config[:max_history]
      end

      def display_ai_response(content)
        print "Akashic: "
        formatted_content = TTY::Markdown.parse(content)

        formatted_content.each_char do |char|
          print char
          $stdout.flush
          sleep @config[:typing_speed]
        end
        puts "\n"
      end

      def display_user_message(message)
        Akashic.prompt.say "You: #{message}"
      end

      def get_user_input
        message = Akashic.prompt.ask "You: "
        message&.strip
      end

      def should_exit?(message)
        message&.downcase&.strip == "exit"
      end

      def handle_error(spinner, message)
        spinner.error
        puts message
      end
    end
  end
end
