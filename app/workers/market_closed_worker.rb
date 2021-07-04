class MarketClosedWorker < ApplicationJob
  queue_as :closed_market

  rescue_from(StandardError) do |exception|
    puts exception.message
  end

  def perform
    Round.close_market
  end
end
