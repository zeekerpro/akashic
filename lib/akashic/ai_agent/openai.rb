require 'openai'

module Akashic
  class AiAgent

    class Openai
      def initialize
        # openai default config
        OpenAI.configure do |config|
          Akashic.config.dig(:openai).each_pair do |key, value|
            config.send("#{key}=", value) if config.respond_to?("#{key}=") and value.present?
          end
        end

        @client = OpenAI::Client.new
      end

      def chat(message)
        Akashic.prompt.say "Akashic: "
        response = @client.chat(
          parameters: {
            model: "gpt-4o", # Required.
            messages: [{ role: "user", content: message }], # Required.
            temperature: 0.7,
            stream: proc do |chunk, _bytesize|
              content = chunk.dig("choices", 0, "delta", "content")
              print content
            end
          }
        )
        print "\n"
      end


    end

  end
end
