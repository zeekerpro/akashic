require "thor"
require_relative "config"
require_relative "shell_integration"
require_relative "ai_agent"

module Akashic
 class CLI < Thor
   desc "init", "Initialize Akashic configuration"
   def init
     Config.setup
   end

   desc "start_chat [*MESSAGE]", "Start the AI chatbot with an optional initial message"
   def start_chat(*message)
      begin
        Akashic.prompt.ok "Welcome to the Akashic! Type your message or 'exit' to quit."
        agent = AiAgent.new
        initial_message = message.any? ? message.join(" ") : nil
        agent.session initial_message
        Akashic.prompt.ok "Thank you for chatting! Have a good day!"
      rescue TTY::Reader::InputInterrupt, Interrupt
        Akashic.prompt.error "\nGoodbye! Thanks for using Akashic!"
        exit(0)
      end
   end

   def self.exit_on_failure?
     true
   end

   # Todo
   desc "integration_shell", "Integrate with shell"
   def integration_shell
     ShellIntegration.setup_shell_hook
   end
 end
end
