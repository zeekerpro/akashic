require_relative "./ai_agent/openai"

module Akashic

  class AiAgent

    # Hash of supported AI service providers and their corresponding implementations
    SUPPORTED_SERVERS = {
      openai: Openai,
      # anthropic: Anthropic,  # Future possible extension
      # gemini: Gemini        # Future possible extension
    }.freeze

    attr_accessor :client, :server

    # Custom error classes for better error handling
    class Error < StandardError; end
    class UnsupportedServerError < Error; end
    class ConfigurationError < Error; end

    # Initialize the AI agent with a specific server type
    # @param server_type [Symbol, String, nil] The type of AI server to use (defaults to :openai)
    def initialize
      @server = Akashic.config[:server].to_sym || :openai

      unless SUPPORTED_SERVERS.key?(@server)
        raise UnsupportedServerError, "Unsupported server type: #{@server}. Supported types: #{SUPPORTED_SERVERS.keys.join(', ')}"
      end

      @client = SUPPORTED_SERVERS[@server].new
    end

    # Implements method_missing to delegate unknown methods to the client
    # This allows direct access to client methods through the AiAgent instance
    # @example agent.chat(...) will be delegated to agent.client.chat(...)
    def method_missing(method, *args, &block)
      if @client.respond_to?(method)
        @client.send(method, *args, &block)
      else
        super
      end
    end

    # Required for proper method_missing implementation
    # Ensures respond_to? works correctly with delegated methods
    def respond_to_missing?(method, include_private = false)
      @client.respond_to?(method) || super
    end

  end

end
