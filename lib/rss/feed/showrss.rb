module RSS
  class Feed
    class ShowRSS < RSS::Feed
      class Downloader < RSS::Downloader
        def feed_uri
          "http://showrss.karmorra.info/feeds/all.rss"
        end
      end

      def feed_downloader
        Downloader.new
      end

      def feed_entry_uri feed_entry
        feed_entry.entry_id
      end

      def entry_filename feed_entry
        "#{feed_entry.title.gsub(" ", ".")}.torrent"
      end
    end
  end
end
