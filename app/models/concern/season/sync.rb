require 'active_support/concern'

module Concern::Season::Sync
  extend ActiveSupport::Concern

  # included do
  #   def self.sync
  #     uri = URI("#{ENV['API_PROD']}/seasons/current")
  #     season = Connection.connect(uri)
  #     create(season)
  #   end
  # end
end