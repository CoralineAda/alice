require "open-uri"
require "nokogiri"

module Alice

  module Parser

    class URL
      
      attr_reader :url
      
      def initialize(url)
        @url = url
      end
      
      def preview
        source = Nokogiri::HTML(open(url))
        title_node = source.search("//title")
        source.search("//p").map(&:content).each do |content|
          next if content.length < 25
          snippet ||= ""; snippet << content[0..254]
          break if snippet.length > 255
        end
        snippet = snippet.to_s.strip.gsub(/[\n\r ]+/," ")[0..254]
        title = title_node.nil? ? '' : title_node.text
        return [title, snippet].reject(&:empty?).join('| ')
      rescue Exception => e
        Alice::Util::Logger.info("*** Couldn't process URL preview for #{url}: #{e.backtrace}")
      end
      
    end
    
  end
  
end