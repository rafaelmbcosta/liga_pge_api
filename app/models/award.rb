# module Api
#   module V1
#     class Award < ApplicationRecord
#       belongs_to :dispute_month, optional: true
#       belongs_to :team
#       belongs_to :season
#       belongs_to :round, optional: true
#       enum award_type: { championship: 0, month: 1, league: 2, first_turn: 3, second_turn: 4, golden: 5, currency: 6 }

#       def pay_award
#         self.payed = true
#         self.save
#       end
#     end
#   end
# end
