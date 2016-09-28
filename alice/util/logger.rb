module Alice
  module Util
    class Logger
      def self.info(info)
        begin
          ::Rack::Logger.info(info)
        rescue
          puts info
        end
      end
    end
  end
end
