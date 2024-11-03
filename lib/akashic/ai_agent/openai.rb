require 'openai'

module Akaishic
  class AiAgent

    class Openai
      def initialize(params)
        # openai default config
        OpenAI.configure do |config|
          Akaishic.config.openai.each_pair do |key, value|
            config.send("#{key}=", value) if config.respond_to?("#{key}=")
          end
        end
        @client = OpenAI::Client.new params
      end
    end

  end
end
