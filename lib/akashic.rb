# frozen_string_literal: true
require "active_support"
require "active_support/core_ext"
require_relative "akashic/config"
require_relative "akashic/version"
require_relative "akashic/cli"
require_relative "akashic/shell_integration"
require_relative "akashic/ai_agent"

module Akashic
  class Error < StandardError; end

  class << self
    def prompt
      @prompt ||= TTY::Prompt.new
    end

    def config
      @config ||= Config.load()
    end

  end

end


