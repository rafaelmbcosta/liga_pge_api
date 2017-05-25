module Api
  module V1
    class Season < ApplicationRecord

      validates_presence_of :year

    end
  end
end
