require 'spec_helper'

RSpec.describe Akashic::AiAgent::Openai do
  let(:valid_config) do
    {
      openai: {
        model: "gpt-4o-mini",
        temperature: 0.7,
        access_token: "test_token",
        organization_id: "test_org"
      }
    }
  end

  before do
    allow(Akashic).to receive(:config).and_return(valid_config)
    # Mock TTY::Markdown to avoid actual rendering
    allow(TTY::Markdown).to receive(:parse).and_return("rendered content")
  end

  describe '#initialize' do
    context 'with valid configuration' do
      it 'initializes successfully' do
        expect { described_class.new }.not_to raise_error
      end
    end

    context 'with invalid configuration' do
      let(:invalid_config) { { openai: { model: "gpt-4" } } }

      before do
        allow(Akashic).to receive(:config).and_return(invalid_config)
      end

      it 'raises ConfigurationError' do
        expect { described_class.new }.to raise_error(Akashic::AiAgent::ConfigurationError, /Missing required OpenAI configuration/)
      end
    end
  end

  describe '#chat' do
    let(:agent) { described_class.new }
    let(:spinner) { instance_double(TTY::Spinner) }
    let(:client) { instance_double(OpenAI::Client) }

    before do
      allow(TTY::Spinner).to receive(:new).and_return(spinner)
      allow(spinner).to receive(:auto_spin)
      allow(spinner).to receive(:stop)
      allow(spinner).to receive(:error)
      allow(OpenAI::Client).to receive(:new).and_return(client)
    end

    context 'with empty message' do
      it 'returns early without making API call' do
        expect(client).not_to receive(:chat)
        agent.chat("")
      end
    end

    context 'with markdown formatting' do
      let(:test_message) { "Show me markdown with **bold** and *italic*" }
      
      it 'handles streaming response with markdown' do
        expect(client).to receive(:chat) do |params|
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "Here's **bold** "}}]})
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "and *italic* "}}]})
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "and ```code```"}}]})
        end

        expect { agent.chat(test_message) }.to output.to_stdout
      end

      it 'resets waiting_for_first_chunk after completion' do
        expect(client).to receive(:chat) do |params|
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "test"}}]})
        end

        agent.chat(test_message)
        expect(agent.instance_variable_get(:@waiting_for_first_chunk)).to be true
      end
    end
    
    context 'with code blocks' do
      let(:test_message) { "Show me a Ruby code example" }
      
      it 'properly formats code blocks' do
        expect(client).to receive(:chat) do |params|
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "```ruby\n"}}]})
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "def hello\n  puts 'world'\nend"}}]})
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "\n```"}}]})
        end

        expect { agent.chat(test_message) }.to output.to_stdout
      end

      it 'handles nested code blocks' do
        expect(client).to receive(:chat) do |params|
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "Outer text ```ruby\n"}}]})
          params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "code\n```\nMore text ```js\ncode```"}}]})
        end

        expect { agent.chat(test_message) }.to output.to_stdout
      end
    end

    context 'with API errors' do
      let(:test_message) { "Test message" }

      it 'handles OpenAI errors gracefully' do
        allow(client).to receive(:chat).and_raise(OpenAI::Error.new("API Error"))
        expect(spinner).to receive(:error).with("OpenAI Error: API Error")
        agent.chat(test_message)
      end

      it 'handles unexpected errors gracefully' do
        allow(client).to receive(:chat).and_raise(StandardError.new("Unexpected"))
        expect(spinner).to receive(:error).with("Unexpected error: Unexpected")
        agent.chat(test_message)
      end
    end
  end

  describe '#conversation_history' do
    let(:agent) { described_class.new }
    let(:test_message) { "Test message" }
    let(:client) { instance_double(OpenAI::Client) }

    before do
      allow(OpenAI::Client).to receive(:new).and_return(client)
    end

    it 'maintains conversation history within limits' do
      expect(client).to receive(:chat).exactly(11).times do |params|
        params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "Response"}}]})
      end

      11.times { agent.chat(test_message) }
      history = agent.instance_variable_get(:@conversation_history)
      expect(history.length).to eq(10)
    end

    it 'alternates between user and assistant messages' do
      expect(client).to receive(:chat) do |params|
        params[:parameters][:stream].call({"choices" => [{"delta" => {"content" => "Response"}}]})
      end

      agent.chat(test_message)
      history = agent.instance_variable_get(:@conversation_history)
      expect(history[0][:role]).to eq("user")
      expect(history[1][:role]).to eq("assistant")
    end
  end
end
