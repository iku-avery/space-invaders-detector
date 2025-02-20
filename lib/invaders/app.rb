# frozen_string_literal: true

module Invaders
  class App
    INVADERS_DATA = [
      'data/invaders/invader_01.txt',
      'data/invaders/invader_02.txt'
  ].freeze

    def scan(file_path)
      @file_path = file_path

      puts "Scan #{@file_path}...\n\n"

      load_radar
      invaders = load_invaders

      puts "INVADERS\n\n"
      invaders.each { |invader| invader.display; puts "\n" }
    end

    def parser
      @parser ||= Invaders::Parser.new
    end

    def load_radar
      radar = Invaders::Matrix.new
      radar.load_data(File.read(@file_path), parser)
      radar
    end

    def load_invaders
      invaders = []
      INVADERS_DATA.each do |invader_data|
        invader = Invaders::Matrix.new
        invader.load_data(File.read(invader_data), parser)
        invaders << invader
      end
      invaders
    end
  end
end
