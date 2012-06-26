require 'mechanize'

module RSS
  class Feed
    def self.escape_brackets uri
      uri.sub("[", "%5B").sub("]", "%5D")
    end

    def aggregate
      feed = feed_downloader.download

      match_entries(feed).each do |feed_entry|
        unless HistoryLog.remembers? entry_filename(feed_entry)
          HistoryLog.remember entry_filename(feed_entry)
          begin
            download feed_entry
          rescue Exception => ex
            RSS::ErrorLog.log e, "RSS Name: #{entry_filename(feed_entry)}, RSS Entry: #{feed_entry_uri(feed_entry)}"
          end
        end
      end
    rescue Exception => ex
      ErrorLog.log ex
    end

    def entry_filename feed_entry
      raise "Implement in subclass!"
    end

    def feed_entry_uri feed_entry
      raise "Implement in subclass!"
    end

    def feed_downloader
      raise "Implement in subclass!"
    end

    private

    def download feed_entry
      uri = RSS::Feed.escape_brackets(feed_entry_uri(feed_entry))
      torrent_file = mechanize.get(uri)

      File.open(feed_entry_path(feed_entry), "w") do |file|
        file.write torrent_file.content
      end
    end

    def match_entries(feed)
      feed.entries.select do |feed_entry|
        match_found? feed_entry
      end
    end

    def match_found? feed_entry
      if RSS::Config.match_entries.empty?
        true
      elsif excluded? feed_entry
        false
      else
        RSS::Config.match_entries.find do |match_entry|
          entry_filename(feed_entry) =~ /#{match_entry}/i
        end
      end
    end

    def excluded? feed_entry
      RSS::Config.exclusions.find do |exclusion|
        entry_filename(feed_entry) =~ /#{exclusion}/i
      end
    end

    def feed_entry_path feed_entry
      RSS::Config.target_directory + "/#{entry_filename(feed_entry)}"
    end

    def mechanize
      @mechanize ||= Mechanize.new do |mechanize|
        mechanize.user_agent_alias = "Linux Firefox"
      end
    end
  end
end
