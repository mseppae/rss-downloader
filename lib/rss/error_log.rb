module RSS
  class ErrorLog
    def self.log error, additional_message = nil
      File.open(error_log, "a") do |log|
        log.write "#{Time.now.strftime('%d.%m.%Y - %H:%M')}: #{error.message} #{additional_message}\n"
      end
    end

    def self.error_log
      RSS::Config.target_directory + "/error_log.txt"
    end
  end
end
