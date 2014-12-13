require "open-uri"
require "nokogiri"

module Parser

  class URL

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def content
      return unless source
      ::Sanitize.fragment(source.content)
    end

    def source
      @source ||= Nokogiri::HTML(open(url))
      @source = nil unless @source.search("//html")
      @source.search("//script").remove
      @source.search("//css").remove
      @source
    rescue Exception => e
      Alice::Util::Logger.info("*** Couldn't process URL for #{url}")
      Alice::Util::Logger.info e.backtrace
    end

    def preview
      return unless source
      title_node = source.search("//title")
      title_node ||= source.search("//h1")
      title_node ||= source.search("//h2")
      snippet = source.xpath("//p").map(&:content).detect do |content|
        content.length > 25
      end
      snippet = truncate(snippet.to_s.strip.gsub(/[\n\r ]+/," ")).split('|')[0]
      title   = truncate(title_node.nil? ? '' : title_node.text)
      return [title, snippet].reject(&:empty?).join(' | ')
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
