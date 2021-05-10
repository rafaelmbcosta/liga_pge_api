module Subscriptions
  class SeasonUpdated < Subscriptions::BaseSubscription
    field :pamonha, String, null: false

    def pamonha
      'Tapioca'
    end
  end
end