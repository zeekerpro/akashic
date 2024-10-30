module Akashic
  module Integration
   def self.setup_shell_hook
     zshrc_path = File.join(Dir.home, ".zshrc")
     hook = <<~HOOK
       command_not_found_handler() {
         akashic chat "$@"
       }
     HOOK

     File.open(zshrc_path, "a") { |file| file.puts hook }
     say("Shell integration added to #{zshrc_path}", :green)
   end
 end
end
