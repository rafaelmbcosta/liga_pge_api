module Api
  module V1
    class MarketStatus
      def self.verify_season(year)
        season = Season.find{|s| s.year == year}
        if season.nil?
          # gotta update the dispute months
          previous_season = Season.find{|s| s.year == (year - 1)}
          previous season.finished = true
          season = Season.create(year: year, finished: false)
          # DisputeMonth.create(number: 1, season: season, details: "Primeiro mês de disputa", rounds: [1])
          # if this happen, teams need to be included for the new season
        end
        return season
      end

      def self.verify_round(number, season)
       round = Round.find{|r| r.season.id == season.id and r.number == number}
       if round.nil?
         ## verify if its golden (on seasons)
         golden = season.golden_rounds.include?(number)
         ## verify dispute month (if configured )
         dispute = DisputeMonth.find{|d| d.season_id == season.id and d.dispute_rounds.include?(number)}
         round = Round.create(number: number, season: season, dispute_month: dispute, golden: golden, finished: false)
         ## new battles
         ## finish previous battles
         ## verify winners
         ## update rankings
       end
       return round
      end

      def self.perform
        #{"rodada_atual"=>16, "status_mercado"=>1,
        # "esquema_default_id"=>4, "cartoleta_inicial"=>100,
        # "max_ligas_free"=>2, "max_ligas_pro"=>5, "max_ligas_matamata_free"=>5,
        # "max_ligas_matamata_pro"=>5, "max_ligas_patrocinadas_free"=>2,
        # "max_ligas_patrocinadas_pro_num"=>2, "game_over"=>false,
        # "temporada"=>2017, "reativar"=>false, "times_escalados"=>2260072,
        # "fechamento"=>{"dia"=>22, "mes"=>7, "ano"=>2017, "hora"=>14, "minuto"=>0,
        #   "timestamp"=>1500742800},
        # "mercado_pos_rodada"=>true, "aviso"=>""}
        market_status = Connection.market_status
        unless market_status["game_over"]
          season = verify_season(market_status["temporada"])
          current_round = market_status["rodada_atual"]
          round = verify_round(current_round, season)
          #verifica se já tem temporada
          if market_status["status_mercado"] == 2
            PartialScore.perform
          end
        end
      end
    end
  end
end
