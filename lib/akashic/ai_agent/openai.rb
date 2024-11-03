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

      def session(message)
        loop do
          if message.present?
            Akashic.prompt.say "You: #{message}"
         else
           message = Akashic.prompt.ask "You: "
           break if message&.downcase == "exit"
           next if !message.present? or message.strip.empty?
         end
         response = chat(message)
         message = nil
       end
      end

      def chat(message)
        spinner = TTY::Spinner.new("Akashic: [:spinner] Thinking...", format: :dots_8, output: $stdout, clear: true)
        spinner.auto_spin

        content = @client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [{ role: "user", content: message }],
            temperature: 0.7
          }
        ).dig("choices", 0, "message", "content")

        spinner.stop
        print "Akashic: "

        formatted_content = TTY::Markdown.parse(content)
        formatted_content.each_char do |char|
          print char
          $stdout.flush
          sleep 0.005
        end
        puts("\n")
      end

    end

  end
end
