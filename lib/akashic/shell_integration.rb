module Akashic
  module ShellIntegration
   def self.setup_shell_hook
     zshrc_path = File.join(Dir.home, ".zshrc")
     hook = <<~HOOK
       command_not_found_handler() {
         akashic start_chat "$@"
       }
     HOOK

     File.open(zshrc_path, "a") { |file| file.puts hook }
     Akashic.prompt.ok "Shell integration added to #{zshrc_path}"
   end
 end
end
