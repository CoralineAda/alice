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
        snippet = source.xpath("//p").map(&:content).detect do |content|
          content.length > 25
        end
        snippet = truncate(snippet.to_s.strip.gsub(/[\n\r ]+/," "))
        title   = truncate(title_node.nil? ? '' : title_node.text)
        return [title, snippet].reject(&:empty?).join(' | ')
      rescue Exception => e
        Alice::Util::Logger.info("*** Couldn't process URL preview for #{url}: #{e.backtrace}")
      end

      private

      def truncate(text, max_length = 255)
        if text.length > max_length
          "#{text[0..max_length].gsub(/\s+$/, '')}..."
        else
          text
        end
      end

    end

  end

end