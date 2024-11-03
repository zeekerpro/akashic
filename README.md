# Akashic

![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%202.6.0-ruby)
![License](https://img.shields.io/badge/license-MIT-green)

Akashic is an intelligent terminal assistant inspired by the Akashic Records—a metaphysical concept of a compendium that holds all universal knowledge and experience. This tool brings intelligent interaction to your terminal by emulating the wisdom of the Akashic Records.

## Author

- zeeker (zeekerpro@gmail.com)

## Features

- **🤖 Smart Command Parsing**: Automatically distinguishes between system commands and natural language queries.
- **🧠 AI-Powered**: Integrated with OpenAI GPT models for intelligent responses.
- **🔄 Elegant Interaction**: Provides beautiful terminal output with Markdown rendering.
- **⚡ Shell Integration**: Seamlessly integrates with your shell environment (currently supports zsh).
- **🎨 Graceful Display**: Offers typewriter effects and progress indicators.

## Installation

```bash
gem install akashic
```

## Configuration

To set up Akashic for the first time, run:

```bash
akashic init
```

This command will guide you through the configuration process, including:
- Selecting the AI service provider (currently supports OpenAI).
- Configuring API keys and other necessary settings.
- Automatically creating a configuration file at `~/.akashic.yml`.

## Usage

### 1. Direct Chat Mode
```bash
akashic start_chat
```

### 2. Shell Integration

This adds the necessary configurations to your `.zshrc` to enable Akashic to handle unknown commands.

### 3. Exiting Conversations
- Type `exit` to end the conversation.
- Use `Ctrl+C` to interrupt at any time.

## Project Structure

```plaintext
lib/
├── akashic/
│   ├── ai_agent/        # AI client implementations
│   ├── cli.rb           # Command line interface
│   ├── config.rb        # Configuration management
│   └── version.rb       # Version information
```

## Contributing

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -am 'Add some amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Create a Pull Request.

## License

This project is licensed under the MIT License. See [LICENSE.txt](LICENSE.txt) for details.

## Acknowledgments

Special thanks to:
- Contributors who have helped shape this project.
- The concept of Akashic Records for inspiration.
- The Ruby community for excellent gems and tools.

## Future Plans

- Support for additional AI models.
- Enhanced shell integration features.
- Multi-language support.
- Plugin system for extensibility.
- Advanced conversation memory management.

---

> "As the Akashic Records hold the universe's wisdom, let this tool bring that wisdom to your terminal."

For more information, bug reports, or feature requests, visit the [GitHub repository](https://github.com/zeekerpro/akashic.git).

## Advanced Usage

### Custom Configurations

Customize the `.akashic.yml` file for:
- API endpoints.
- Model selection.
- Response formatting.
- Timeout settings.
- Error logging preferences.

### Shell Integration Features

With shell integration:
- Unknown commands are processed by AI.
- Get intelligent suggestions for command corrections.
- Receive explanations for complex commands.
- Learn shell best practices through AI guidance.

## Todo
dynamic params for chat function



