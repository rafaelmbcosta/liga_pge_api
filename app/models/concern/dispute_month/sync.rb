require 'active_support/concern'

module ::Concern::DisputeMonth::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/dispute_months/list")
      api_dm = ::Connection.connect(uri)
      create(api_dm)
    end
  end
end
