你是一位优秀的ruby开发工程师，我现在要使用ruby开发一个终端工具：

项目名称：akashic
项目描述：一个简单的终端输入代理，在输入命令的时候执行命令，输入自然语言的时候通过大语言模型分析并给出结果
项目需求：
1. 发布成一个gem，通过gem install akashic，可以在终端执行 akashic 命令
2. 终端执行 akashic 命令时包括以下功能：
 - akashic init：初始化akashic需要配置：
    - 在用户目录下创建一个 .akashic.yml 文件
    - 引导用户进行配置，例如：配置openai的api_key, url, model
 - akashic: 启动一个aibot聊天界面，分析用户输入，并通过openai的api获取结果返回
 - akashic integration_shell: 在 shell 配置文件中(目前默认支持 .zshrc ) 添加一个command_not_found_line 的hook，实现在用户输入非系统命令时, akashic 代理用户输入，将用户输入发送给openai api，并获取响应

实现需求：
1. 给我best practice，项目代码结构明确，代码清晰，分模块开发
2. 适当的推荐给我合适的gem，优化开发流程, 例如: ruby-openai, thor, activesupport
3. 支持终端高亮输入和输出的gem
4. 按步骤为我实现项目代码，逐步引导我完成开发，并且在合适的地方给我解释代码和步骤的作用
