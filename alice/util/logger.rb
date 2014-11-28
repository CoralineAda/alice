require 'raad'
require 'raad/logger'

module Alice
  module Util
    class Logger
      include Raad::Logger
      def self.info(info)
        begin
          ::Raad::Logger.info(info)
        rescue
          puts info
        end
      end
    end
  end
end