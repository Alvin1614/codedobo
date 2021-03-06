# frozen_string_literal: true

require 'json'

class CodeDoBo
  class Language
    #
    # Language system for individual servers
    #
    # @param [Sequel::Database] client <description>
    # @param [String] folder Where all language files are (see MainModule)
    #
    def initialize(client, folder)
      @folder = folder
      @client = client
    end

    # Returns a hash with the file name as key
    # @return [Hash{String=>String}] Hash{ServerID=> Language}
    attr_reader :language

    # The folder of the translations
    # @return [String]
    attr_reader :folder

    def get(serverID)
      get_file(@client[:main].first(server_id: serverID)[:language])
    end

    def get_file(language)
      path = "#{@folder}/#{language}.json"
      return unless File.file? path

      file = File.open path
      file
    end

    #
    # Get the json file from the server id
    #
    # @param [String] serverID
    # @param [String] default_language
    #
    # @return [Hash]
    #
    def get_json(serverID,default_language="en")
      data = JSON.load(get_file(default_language))
      file = get(serverID)
      data.deep_merge!(JSON.load(file)) if file
      return data
    end

    #
    # Get all values of this key from all language files
    #
    # @param [Array(String)] *keys
    #
    # @return [Hash{String => Object}]
    #
    def get_language_hash(*keys)
      hash = {}
      languages.each{ |language|
        path = "#{@folder}/#{language}.json"
        data = JSON.load File.open path
        value = data
        keys.each {|key|
          value = value[key]
        }
        hash[language] = value
      }
      hash
    end

    def languages
      languages = []
      Dir.foreach(@folder) do |file|
        languages.push File.basename(file,File.extname(file))  if file.end_with?(".json")
      end
      languages
    end
  end
end
