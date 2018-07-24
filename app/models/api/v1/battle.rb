module Api
  module V1
    class Battle < ApplicationRecord
      belongs_to :round

      def self.list_battles
        $redis.get("battles")
      end
    end
  end
end
