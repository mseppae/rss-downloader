require 'open-uri'
require 'feedzirra'
require 'config_reader'

module RSSDownloader
  class Eztv
    def self.aggregate_feed
      Feedzirra::Feed.add_common_feed_entry_elements(:torrent)
      feed = Feedzirra::Feed.fetch_and_parse(RSSDownloader::Config.feed_uri)

      match_entries(feed).each do |feed_entry|
        download feed_entry
      end
    end

    private

    def self.download feed_entry
      unless File.exists? feed_entry_path(feed_entry)
        uri = escape_brackets(feed_entry.url)
        torrent_file = open(uri)

        File.write(feed_entry_path(feed_entry), "w") do |file|
          file.write torrent_file.read
        end
      end
    end

    def self.match_entries(feed)
      feed.entries.select do |feed_entry|
        match_found? feed_entry
      end
    end

    def self.match_found? feed_entry
      if RSSDownloader::Config.match_entries.empty?
        true
      else
        RSSDownloader::Config.match_entries.find do |match_entry|
          entry_filename(feed_entry) =~ /#{match_entry}/i
        end
      end
    end

    def self.feed_entry_path feed_entry
      RSSDownloader::Config.target_directory + "/#{entry_filename(feed_entry)}"
    end

    # Quick and dirty
    def self.entry_filename feed_entry
      feed_entry.torrent.first.strip.split("\n\t\t\t\t").first
    end

    # Quick and dirty
    def self.escape_brackets uri
      uri.sub("[", "%5B").sub("]", "%5D")
    end
  end

  class Config < ConfigReader
    self.config_file = 'config/config.yml'
  end
end
