module RSS
  class HistoryLog
    def self.remember entry
      File.open(history_log, "a") do |log|
        log.write "#{entry}\n"
      end
    end

    def self.remembers? entry
      if File.exist? history_log
        File.read(history_log).include?(entry)
      else
        false
      end
    end

    def self.history_log
      RSS::Config.target_directory + "/rss_history.txt"
    end
  end
end
