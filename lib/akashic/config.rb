require "yaml"
require "tty-prompt"

module Akashic
  module Config
    CONFIG_FILE = File.join(Dir.home, ".akashic.yml")

    def self.setup
      prompt = TTY::Prompt.new

      prompt.ok( "Let's set up your Akashic configuration interactively.")

      # 获取 OpenAI API 配置
      api_key = nil
      2.times do
        api_key = prompt.mask("Enter your OpenAI API key:")
        break unless api_key.nil? || api_key.strip.empty?
      end

      if api_key.nil? || api_key.strip.empty?
        prompt.error( "API key is required. Exiting setup.")
        exit
      end

      model = prompt.select("Select the OpenAI model you want to use:", %w[gpt-3.5-turbo gpt-4, gpt-4o-mini, gpt-4o], default: "gpt-4o-mini")

      url = prompt.ask("Enter the OpenAI API URL:", default: "https://api.openai.com/")

      config = {
        "openai" => {
          "api_key" => api_key,
          "url" => url,
          "model" => model
        }
      }

      File.write(CONFIG_FILE, config.to_yaml)
      puts "Configuration saved to #{CONFIG_FILE}"
    end

  end
end

