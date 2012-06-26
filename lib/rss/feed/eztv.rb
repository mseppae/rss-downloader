module RSS
  class Feed
    class Eztv < RSS::Feed
      class Downloader < RSS::Downloader
        def initializer
          Feedzirra::Feed.add_common_feed_entry_elements(:torrent)
        end

        def feed_uri
          "http://www.ezrss.it/feed/"
        end
      end

      def feed_downloader
        Downloader.new
      end

      def feed_entry_uri feed_entry
        feed_entry.url
      end

      def entry_filename feed_entry
        feed_entry.torrent.first.strip.split("\n\t\t\t\t").first
      end
    end
  end
end
