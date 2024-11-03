require "thor"
require_relative "config"
require_relative "integration"
require_relative "ai_agent"

module Akashic
 class CLI < Thor
   desc "init", "Initialize Akashic configuration"
   def init
     Config.setup
   end

   desc "chat", "Start the AI chatbot"
   def chat
     Akashic.prompt.ok "Welcome to the Akashic! Type your message or 'exit' to quit."

     agent = AiAgent.new

     loop do
       message = Akashic.prompt.ask "You: "
       next if !message.present? or message.strip.empty?
       break if message.downcase == "exit"
       response = agent.chat(message)
     end

     Akashic.prompt.ok "Thank you for chatting! Have a good day!"
   end

   # Todo
   desc "integration_shell", "Integrate with shell"
   def integration_shell
     Integration.setup_shell_hook
   end
 end
end
