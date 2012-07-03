require 'feedzirra'

module RSS
  class Downloader
    def download
      response = feed_parser.fetch_and_parse(feed_uri)

      if response.is_a? Feedzirra::Parser::RSS
        response
      else
        raise "RSS Feed #{feed_uri} returned errorenous response: #{response}!"
      end
    end

    def feed_uri
      raise "Implement in Subclass!"
    end

    def feed_parser
      Feedzirra::Feed
    end
  end
end
