module Api
  module V1
    class Award
      def self.award_champions
        
      end

      def self.award_first_turn

      end

      def self.award_golden(round)

      end

      def self.award_month(dispute)

      end

      def self.award_league(dispute)

      end

      def self.award_currency(dispute)

      end

      def self.perform(round)
        dispute = round.dispute_month
        # Championship AND  second_turn
        award_champions if round.number == 38
        # First turn (check if its in the middle of the month)
        award_first_turn if round.number == 19

        ## Golden round
        award_round(round) if round.golden

        # Monthly awards:
        if dispute.dispute_rounds.last == round.number
          ## Month
          award_month(dispute)
          ## League
          award_league(dispute)
          ## Patrimônio
          award_currency(dispute)
      end
    end
  end
end
