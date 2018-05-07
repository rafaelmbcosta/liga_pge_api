class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # New rule, if the league have more than 35 players, we have 4 winners
  def split_prizes(active_players, prize_pool)
    if active_players.size >= 35
      return prize_pool*0.4, prize_pool*0.3, prize_pool*0.2, prize_pool*0.1
    else
      return prize_pool*0.5, prize_pool*0.3, prize_pool*0.2
    end
  end
end
