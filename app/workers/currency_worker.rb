class CurrencyWorker < ApplicationJob
  queue_as :currencies

  after_perform :show_currencies

  def perform(round)
    Currency.save_currencies(round)
  end

  private
  def show_currencies
    Currency.show_currencies
  end
end
