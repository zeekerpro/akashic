require_relative "./ai_agent/openai"

module Akashic

  class AiAgent

    attr_accessor :client, :server

    def initialize
      case Akashic.config[:server].to_sym
      when :openai
      # Todo: Add more cases here if needed for other server types
        @server = :openai
        @client = Openai.new
      else
        raise "Unsupported server type"
      end
    end

    # dynimically delegate methods to the client, so that we can call the client methods directly from AiAgent instance
    # methods: chat, chat_async, chat_async_wait, assistant, knowledge_base and so on
    def method_missing(method, *args, &block)
      if @client.respond_to?(method)
        @client.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @client.respond_to?(method) || super
    end

  end

end
