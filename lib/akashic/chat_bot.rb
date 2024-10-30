require "openai"
require "yaml"
require "pastel"

module Akashic
 module ChatBot
   def self.start_chat
     pastel = Pastel.new
     config = YAML.load_file(Akashic::Config::CONFIG_FILE)
     client = OpenAI::Client.new(api_key: config["openai"]["api_key"])

     say(pastel.green("Starting Akashic Chatbot. Type 'exit' to quit."))
     loop do
       input = ask(pastel.yellow("You: "))
       break if input.strip.downcase == "exit"

       response = client.chat(parameters: {
         model: config["openai"]["model"],
         messages: [{ role: "user", content: input }]
       })

       say(pastel.cyan("AI: #{response.dig("choices", 0, "message", "content")}"))
     end
   end
 end
end
