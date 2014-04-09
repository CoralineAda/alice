module Alice

  module Handlers
    
    class Response

      include PoroPlus

      attr_accessor :kind
      attr_accessor :content
      
      def content
        Alice::Util::Sanitizer.process(@content)
      end

    end

  end

end