# frozen_string_literal: true

require_relative "lib/akashic/version"

Gem::Specification.new do |spec|
  spec.name = "akashic"
  spec.version = Akashic::VERSION
  spec.authors = ["zeeker"]
  spec.email = ["zeekerpro@gmail.com"]

  spec.summary = "Akashic - A smart terminal input proxy with command execution and AI analysis."
  spec.description = "Akashic is a terminal input proxy that allows users to interact with their terminal in a more intelligent way. It distinguishes between standard shell commands and natural language queries. For shell commands, Akashic directly executes them in the terminal. For natural language queries, Akashic uses an AI model, such as OpenAI's GPT, to provide meaningful responses. Akashic supports Zsh and includes an 'install' command that edits shell configuration files, such as .zshrc, to seamlessly add its proxy support. It's distributed as a Ruby Gem to provide easy installation and integration."
  spec.homepage = "https://github.com/zeeker/akashic"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zeeker/akashic"
  spec.metadata["changelog_uri"] = "https://github.com/zeeker/akashic/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-openai"
  spec.add_dependency "thor"
  spec.add_dependency "colorize"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "tty-markdown"
  spec.add_dependency 'tty-spinner'
  spec.add_dependency "highline"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "debug"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
