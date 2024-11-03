require "yaml"
require "tty-prompt"

module Akashic

  class Config
    CONFIG_FILE = File.join(Dir.home, ".akashic.yml")

    class << self

      def load
        if File.exist?(CONFIG_FILE)
          Akashic.prompt.ok("Configuration loaded => #{@config}")
        else
          Akashic.prompt.error("Configuration file not found. Let's set it up now!")
          Config.setup
        end
        @config = YAML.load_file(CONFIG_FILE)
      end

      def setup
        Akashic.prompt.ok( "Let's set up your Akashic configuration interactively.")

        # Todo: suuprt more AI server, such as gemini, ollama, Anthropic, etc.
        server = Akashic.prompt.select("Select the AI client to use:", %w[openai], default: "openai")

        openai = collect_openai_config if server == "openai"

        config = {
          :server => server,
          :openai => openai
        }

        File.write(CONFIG_FILE, config.to_yaml)
        Akashic.prompt.say "Configuration saved to #{CONFIG_FILE}"
      end


      private

      def collect_openai_config
        api_key = nil
        2.times do
          api_key = Akashic.prompt.mask("Enter your OpenAI API key:")
          break unless api_key.nil? || api_key.strip.empty?
        end

        if api_key.nil? || api_key.strip.empty?
          Akashic.prompt.error("API key is required. Exiting setup.")
          exit
        end

        url_base = Akashic.prompt.ask("Enter the OpenAI API URL_BASE:", default: "https://api.openai.com/")
        is_log_errors = Akashic.prompt.yes?("Log errors?", default: true)
        organization_id = Akashic.prompt.ask("Enter your OpenAI organization ID:")
        request_timeout = Akashic.prompt.ask("Enter the request timeout in seconds:", default: 240)
        extra_headers = Akashic.prompt.ask("Enter any extra headers to include in the request:")

        {
          api_key: api_key,
          url_base: url_base,
          log_errors: is_log_errors,
          organization_id: organization_id,
          request_timeout: request_timeout,
          extra_headers: extra_headers
        }
      end

    end

  end

end

