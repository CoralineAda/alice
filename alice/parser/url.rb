require "open-uri"
require "nokogiri"

module Parser

  class URL

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def content
      return unless document_body = source
      @content ||= begin
        this_content = Nokogiri::HTML(document_body.to_s)
        this_content.search("//script").remove
        this_content.search("//css").remove
        this_content
      end
    end

    def source
      file = open(url)
      file.content_type == "text/html" && file.read
    rescue Exception => e
      Alice::Util::Logger.info("*** Couldn't process URL for #{url}")
      Alice::Util::Logger.info e.backtrace
    end

    def preview
      return unless content.present?
      title_node = content.search("//title")
      title_node ||= content.search("//h1")
      title_node ||= content.search("//h2")
      snippet = content.xpath("//p").map(&:content).detect do |content|
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
