# frozen_string_literal: true

require_relative './console_cmd_manager.rb'
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end
class CodeDoBo
  def initialize(discord, client, logs = true)
    @discord = discord
    @client = client
    @server_prefix = {}
    setup
    @logs = logs
    @module_manager = CodeDoBo::ModuleManager.new(self, client)
    @user_cmd_manager = CodeDoBo::UserCommandManager.new(self, @module_manager)
    @console_cmd_manager = CodeDoBo::ConsoleCommandManager.new(self, @module_manager)
    @module_manager.detect
  end
  # @return [Discordrb::Bot]
  attr_reader :discord
  attr_reader :user_command
  attr_reader :database
  attr_reader :server_prefix
  attr_reader :console_command
  def run
    log "\u001b[36mStarting discord bot..."
    discord.run(true)
    discord.game = "github/codedobo " + CodeDoBo.version
    @module_manager.start
    @console_cmd_manager.run
    @user_cmd_manager.run
    log "\u001b[32mSuccessfully started discord bot!"
  end

  def stop
    puts 'Bye'
    discord.stop(true)
    @module_manager.stop
    @console_cmd_manager.stop
  end

  def restart
    @user_cmd_manager.stop
    @console_cmd_manager.stop
    @module_manager.restart
    @console_cmd_manager.run
    @user_cmd_manager.run
  end

  def self.version
    'Beta 1.1.2'
  end

  def self.developer
    'CodeDoctorDE'
  end

  def log(text)
    puts text
    return unless @logs
    
    File.open('./logs.txt', 'a') do |file|
      file.puts Time.now.inspect + ": " + text
    end
  end
end
