# Akashic

**A smart terminal input proxy with command execution and AI analysis**

Akashic is a terminal input proxy that allows users to interact with their terminal in a more intelligent way. It distinguishes between standard shell commands and natural language queries. For shell commands, Akashic directly executes them in the terminal. For natural language queries, Akashic uses an AI model, such as OpenAI's GPT, to provide meaningful responses. Akashic supports Zsh and includes an `install` command that edits shell configuration files, such as `.zshrc`, to seamlessly add its proxy support.

## Features
- **Command Execution**: Recognizes and runs standard shell commands directly.
- **AI Analysis**: Processes natural language inputs with an AI model to provide smart responses.
- **Zsh Support**: Designed to integrate smoothly with Zsh.
- **Simple Installation**: The `install` command configures the terminal environment automatically.

## Installation

To install Akashic, you'll need to have Ruby installed. Then you can add Akashic as a gem:

```sh
gem install akashic
```

After installing the gem, run the following command to configure Akashic in your terminal:

```sh
akashic install
```

This command will update your `.zshrc` or other shell configuration file to enable Akashic as a proxy for terminal input.

## Usage

Akashic can be used directly from your terminal:

### Executing Commands

For shell commands, Akashic will run them as usual:

```sh
akashic ls -al
```

This will output the result of the `ls -al` command.

### Natural Language Queries

For natural language inputs, Akashic will use an AI model to provide answers:

```sh
akashic "What is the capital of France?"
```

The response will be retrieved from the AI model and displayed in the terminal.

## Configuration

Akashic requires an OpenAI API key for natural language processing. You need to set your API key as an environment variable:

```sh
export OPENAI_API_KEY="your_openai_api_key_here"
```

This key will be used to communicate with the OpenAI API to get responses for natural language inputs.

## Development

To contribute to Akashic, clone the repository and install the dependencies:

```sh
git clone https://github.com/your_username/akashic.git
cd akashic
bundle install
```

You can run the gem locally for testing:

```sh
bin/akashic "Hello, what time is it?"
```

## Release

To release a new version of Akashic, update the version number in `akashic.gemspec`, and then run:

```sh
gem build akashic.gemspec
gem push akashic-<version>.gem
```

## License

Akashic is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgements

- **Thor**: For handling CLI commands.
- **OpenAI**: For providing the language model used in natural language queries.
- **TTY-Prompt**: For interactive prompts and improving user experience.

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests for any improvements or features you'd like to see.

## Contact

For any questions or suggestions, please feel free to reach out at [zeekerpro@gmail.com].


