require "thor"
require "akashic/config"
require "akashic/chat_bot"
require "akashic/integration"
require "pastel"

module Akashic
 class CLI < Thor
   desc "init", "Initialize Akashic configuration"
   def init
     Config.setup
   end

   desc "chat", "Start the AI chatbot"
   def chat
     ChatBot.start_chat
   end

   desc "integration_shell", "Integrate with shell"
   def integration_shell
     Integration.setup_shell_hook
   end
 end
end
