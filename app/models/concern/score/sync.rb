require 'active_support/concern'

module ::Concern::Score::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/scores")
      scores = ::Connection.connect(uri)
      create(scores)
    end
  end
end