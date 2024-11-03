require_relative "./ai_agent/openai"

module Akaishic

  class AiAgent

    attr_accessor :client

    def initialize
      case Akashic.config.server.to_sym
      when :openai
      # Todo: Add more cases here if needed for other server types
        @client = Openai.new
      else
        raise "Unsupported server type"
      end
    end

    # Todo: dynimically delegate methods to the client, so that we can call the client methods directly from AiAgent instance
    # methods: chat, chat_async, chat_async_wait, assistant, knowledge_base and so on

  end

end
