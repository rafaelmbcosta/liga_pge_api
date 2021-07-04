class NewRoundWorker < ApplicationJob
  queue_as :new_round

  rescue_from(StandardError) do |exception|
    puts exception.message
  end

  def perform
    Round.new_round
  end
end
