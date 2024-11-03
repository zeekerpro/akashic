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
        # 修改 spinner 的文本，在开始时就包含 "Akaishic: "
        spinner = TTY::Spinner.new("Akaishic: [:spinner] Thinking...", format: :dots_8, output: $stdout, clear: true)
        spinner.auto_spin

        content = @client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [{ role: "user", content: message }],
            temperature: 0.7
          }
        ).dig("choices", 0, "message", "content")

        # 停止时不添加额外文本，因为 "Akaishic: " 已经在前面了
        spinner.stop "Akaishic: "

        formatted_content = TTY::Markdown.parse(content)
        formatted_content.each_char do |char|
          print char
          $stdout.flush
          sleep 0.005
        end
      end

    end

  end
end
