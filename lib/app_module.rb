# frozen_string_literal: true

class CodeDoBo
  # Every module must be a child of this module
  module BotModule
    # @param app_class [CodeDoBo::BotClass]
    # @param module_manager [CodeDoBo::ModuleManager]
    def initialize(app_class, module_manager)
      @module_manager = module_manager
      @app_class = app_class
    end

    # Enable method.
    # @note Add this method to your module to do something
    #   if the module was enabled
    # @return [void]
    def on_enable; end

    # Disable method.
    # @note Add this method to your module to do something
    #   if the module was disable
    # @return [void]
    def on_disable; end

    # Set the prefix of the module for the send and error method
    # @return [String] prefix
    def prefix
      '[' + self.class.to_s + '] '
    end
    
    #
    # When the bot joined on a server
    #
    # @param [Discordrb::Server] server
    # @param [TrueClass] already If the bot was already on this server
    #
    # @return [void]
    def join(server, already); end

    # Send the message with the prefix
    # @return [void]
    def send_message(message)
      @module_manager.bot.log prefix + message + "\e[0m"
    end

    # Send the method in red with the prefix
    # @return [void]
    def error(message)
      @module_manager.bot.log s prefix + "\e[31m" + message + "\e[0m"
    end

    #
    # Send a user help message
    #
    # @param [Discordrb::Member, Discordrb::User] user
    # @param [Discordrb::Channel] channel
    #
    # @return [void]
    #
    def help(user, channel)
      channel.send_message ':x: No help for this module! :x:'
    end
    # @return [CodeDoBo::AppClass]
    attr_reader :app_class
  end
end
