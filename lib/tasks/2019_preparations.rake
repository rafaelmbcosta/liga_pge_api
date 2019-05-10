desc "Prepare the API while there is no ADM Front end"
task :preparations_2019 => :environment do
  # TODO
  # 1) get active seasons
  $season = Api::V1::Season.active
  # add dispute months to season
  $dm = Api::V1::DisputeMonth.create(season: $season, name: 'Abril/Maio', 
                                    dispute_rounds: (1..8).to_a, price: 30.0, 
                                    finished: false)
                                    
                                    
  # 3) create teams
  def create_team(id, name, slug)
    player = Api::V1::Team.find(id)
    team = Api::V1::Team.new(player: player, name: name, slug: slug, season: $season, active: true)
    if team.save
      puts "OK #{name}"
    else
      puts "ERRO #{team.name}"
    end
  end

                                    
  # 2) check active player
  create_team(50, 'Loos Alvinegros', 'loos-alvinegros')
  create_team(20, 'Palestra Candango', 'palestra-candango')
  create_team(38, 'Cearamengolfc', 'cearamengolfc')
  create_team(48, 'FlaMonique1 FC', 'flamonique1-fc')
  create_team(10, 'C.Luiz', 'c-luiz')
  create_team(1, 'Camisa10daGavea', 'camisa10dagavea')
  create_team(46, 'Bessa CSC', 'bessa-csc')
  create_team(8, 'pinico cheio', 'pinico-cheio')
  create_team(9, 'vovo S.C', 'vovo-s-c')
  create_team(33, 'djmss fc', 'djmss-fc')
  create_team(24, 'Vovô do Yan', 'vovo-do-yan')
  player = Api::V1::Player.create(name: 'E.OLIVEIRA', active: true)
  create_team(player.id, 'Superstafx', 'superstafx')
  player = Api::V1::Player.create(name: 'Sidney', active: true)
  create_team(player.id, 'Ceará Sportinng Club', 'ceara-sportinng-club')
  create_team(43, 'Celim Team', 'celim-team')
  create_team(40, 'coringao team1', 'coringao-team1')
  create_team(14, 'Down Futball United', 'down-futball-united')
  create_team(2, 'Boa Viagem E. Clube', 'boa-viagem-e-clube')
  create_team(47, 'Aeroshow SEP', 'aeroshow-sep')
  create_team(36, 'Zanatinha CFC', 'zanatinha-cfc')
  create_team(23, 'Raimundões FC', 'raimundoes-fc')
  create_team(5, 'Fabayern FC', 'fabayern-fc')
  create_team(41, 'Clube Artimanhã', 'clube-artimanha')
  create_team(16, 'Victor Gomes Sporting Club', 'victor-gomes-sporting-club')
  create_team(27, 'Come mosca fc', 'come-mosca-fc')
  create_team(18, 'Victor Santiago FC', 'victor-santiago-fc')
  create_team(3, 'Valério Central F. C', 'valerio-central-f-c')
  create_team(4, 'PerdiCartola FBPA', 'perdicartola-fbpa')
  player = Api::V1::Player.create(name: 'Rennan Amaral', active: true)
  create_team(player.id, 'CearáSCR', 'cearascr')
  create_team(49, 'O Poderoso Chefão 1972', 'o-poderoso-chefao-1972')
  player = Api::V1::Player.create(name: 'Ivonildo lopes', active: true)
  create_team(player.id, 'Losferasfc', 'losferasc')
  player = Api::V1::Player.create(name: 'Júlio Caminha', active: true)
  create_team(player.id, 'TambôdePebaFC', 'tambodepebafc')
  player = Api::V1::Player.create(name: 'Cleirton sel', active: true)
  create_team(player.id, 'Estrela Royale', 'estrela-royale')
  create_team(17, 'Vanduka FC', 'vanduka-fc')
  create_team(15, 'PIEDADE FCF', 'piedade-fcf')
  create_team(12, 'Batista S.C', 'batista-sc')
  create_team(7, 'IslandOfCatsFootball', 'islandofcatsfootball')

  # create rounds one by one ?!
  # (1..4).to_a.each do |round_number|
  #   round = Api::V1::Round.create(number: round_number, season: $season, 
  #                                 dispute_month: $dm, finished: true, 
  #                                 golden: (round.number == 4),
  #                                 finished: (round.number != 4))
  # end

  
  # 5) update scores
end