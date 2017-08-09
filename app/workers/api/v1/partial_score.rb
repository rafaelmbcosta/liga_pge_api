module Api
  module V1
    class PartialScore

      def self.battle_opponent(battle, team, teams)
        battle_class = ""
        if battle.first_id == team.id
          opponent_id = battle.second_id
          battle_class = "success" if  (battle.first_points - battle.second_points > 5)
          battle_class = "danger" if  (battle.first_points - battle.second_points < 5)
        else
          battle_class = "success" if  (battle.first_points - battle.second_points < 5)
          battle_class = "danger" if  (battle.first_points - battle.second_points > 5)
        end
        battle_class
      end

      def self.perform(last_round)
        teams = Team.where(season: last_round.season)
        athletes = Connection.athletes_scores["atletas"]
        scores = []
        teams.each do |team|
          pontuacao = Connection.team_score(team.slug, last_round.number)
          points = 0
          players = 0
          pontuacao["atletas"].each do |athlete|
            athlete_id = athlete["atleta_id"]
            if athletes.include?(athlete_id.to_s)
              points += athletes[athlete_id.to_s]["pontuacao"]
              players += 1
            end
          end
          score = Score.find{|sc| sc.team_id == team.id and  sc.round_id == last_round.id}
          if score.nil?
            score = Score.create(team: team, round: last_round,
                partial_score: points, team_name: team.name,
                player_name: team.player.name, players: players )
          else
            score.update_attributes(partial_score: points, players: players)
          end
          battle = Battle.find{|b| (b.first_id == team.id or b.second_id) and b.round_id == last_round.id}
          attributes = score.attributes
          attributes["team_symbol"] = pontuacao["time"]["url_escudo_png"]
          attributes["battle_class"] = battle_status(battle, team, teams)
          scores << attributes
        end
        $redis.set("partials", scores.sort_by{|r| r["partial_score"]}.reverse.to_json)
        PartialReport.perform
      end
    end
  end
end
