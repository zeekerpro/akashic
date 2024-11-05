module Akashic
  module ShellIntegration
    class << self
      def setup_shell_hook
        shell_info = detect_shell
        return unless shell_info

        shell_type, config_file = shell_info
        hook_content = generate_hook_content(shell_type)

        if confirm_integration(shell_type, config_file, hook_content)
          add_hook_to_config(config_file, hook_content)
          Akashic.prompt.ok "Shell integration has been added to #{config_file}"
        else
          show_manual_integration(shell_type, hook_content)
        end
      end

      private

      def detect_shell
        shell_path = ENV['SHELL']
        return nil unless shell_path

        shell_name = File.basename(shell_path)
        config_file = case shell_name
                     when 'zsh'
                       File.join(Dir.home, '.zshrc')
                     when 'bash'
                       File.join(Dir.home, '.bashrc')
                     # Todo: Add more shells as needed
                     else
                       nil
                     end

        config_file ? [shell_name, config_file] : nil
      end

      def generate_hook_content(shell_type)
        case shell_type
        when 'zsh'
          <<~HOOK
            # Akashic Integration
            command_not_found_handler() {
              akashic start_chat "$@"
            }
          HOOK
        when 'bash'
          <<~HOOK
            # Akashic Integration
            command_not_found_handle() {
              akashic start_chat "$@"
              return 127
            }
          HOOK
        end
      end

      def confirm_integration(shell_type, config_file, hook_content)
        Akashic.prompt.say "\nDetected shell: #{shell_type}"
        Akashic.prompt.say "Configuration file: #{config_file}"
        Akashic.prompt.say "\nThe following content will be added to your shell configuration:"
        Akashic.prompt.say "\n#{hook_content}"

        Akashic.prompt.yes?("Would you like to proceed with the integration?", default: true)
      end

      def add_hook_to_config(config_file, hook_content)
        File.open(config_file, "a") do |file|
          file.puts "\n#{hook_content}"
        end
      end

      def show_manual_integration(shell_type, hook_content)
        Akashic.prompt.warn "\nManual integration instructions:"
        Akashic.prompt.say "To integrate Akashic with your #{shell_type} shell, add the following content to your shell configuration file:"
        Akashic.prompt.say "\n#{hook_content}"
        Akashic.prompt.say "\nAfter adding the content, restart your shell or run: source ~/.#{shell_type}rc"
      end
    end
  end
end
