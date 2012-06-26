require 'config_reader'

module RSS
  class Config < ConfigReader
    self.config_file = 'config/config.yml'
  end
end
