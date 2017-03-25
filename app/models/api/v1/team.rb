class Team < ApplicationRecord
  belongs_to :season
  belongs_to :player
end
