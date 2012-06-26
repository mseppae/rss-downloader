module RSS
  class Aggregator
    def self.aggregate feeds
      feeds.each {|feed| feed.new.aggregate }
    end
  end
end
