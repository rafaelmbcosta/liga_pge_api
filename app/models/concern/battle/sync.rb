require 'active_support/concern'

module ::Concern::Battle::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/battles/details")
      battles = ::Connection.connect(uri)
      create(battles)
    end
  end
end