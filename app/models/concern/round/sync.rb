require 'active_support/concern'

module Concern::Round::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/rounds/finished")
      rounds = Connection.connect(uri)
      create(rounds)
    end
  end
end
