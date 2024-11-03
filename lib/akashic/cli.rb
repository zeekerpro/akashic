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

   desc "start_chat", "Start the AI chatbot"
   def start_chat(message)
      begin
        Akashic.prompt.ok "Welcome to the Akashic! Type your message or 'exit' to quit."
        agent = AiAgent.new
        agent.session message
        Akashic.prompt.ok "Thank you for chatting! Have a good day!"
      rescue TTY::Reader::InputInterrupt, Interrupt
        Akashic.prompt.error "\nGoodbye! Thanks for using Akashic!"
        exit(0)
      rescue Interrupt
        Akashic.prompt.error "\nGoodbye! Thanks for using Akashic!"
        exit(0)
      end
   end

   # Todo
   desc "integration_shell", "Integrate with shell"
   def integration_shell
     ShellIntegration.setup_shell_hook
   end
 end
end
