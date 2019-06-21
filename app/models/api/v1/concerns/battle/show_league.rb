module Api
  module V1
    module Concerns
      module Battle
        # Methods concerning league show
        module ShowLeague
          extend ActiveSupport::Concern

          included do
            def self.dispute_month_league_report(dispute_month, teams)

            end

            def self.show_league
              # find season
              season = Season.active
              teams = Team.all
              # find dispute_months
              league_report = []
              season.dispute_months.each do |dispute_month|
                league_report << dispute_month_league_report(dispute_month, teams)
              end
              # go through league dispute_month
              $redis.set('league', league_report.to_json)
              league_report
            end
          end
        end
      end
    end
  end
end