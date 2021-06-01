class RoundWorker
  def self.perform
    Round.new_round
    Round.close_market
  end
end
