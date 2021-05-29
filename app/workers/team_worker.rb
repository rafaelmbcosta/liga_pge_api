class TeamWorker
  def self.perform
    Team.where(active: true).each do |team|
      puts "TEAM: #{team.name}"
      team_data = Connection.team_score(team.id_tag)
      raise "ERRO TEAM ID: #{team.id}, SLUG: (#{team.slug})" if team_data.nil?
      team.update(url_escudo_png: team_data['time']['url_escudo_png'],
                              player_name: team_data['time']['nome_cartola'],
                              name: team_data['time']['nome'],
                              slug: team_data['time']['slug'])
                              #TODO EDITAR TODOS OS CAMPOS
    end
  end
end
