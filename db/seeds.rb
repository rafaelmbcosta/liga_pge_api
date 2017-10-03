# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# season = FactoryGirl.create(:v1_season)
# players = FactoryGirl.create_list(:v1_player, 50 )
# players.each do |player|
#   FactoryGirl.create(:v1_team, player: player, season: season)
# end

module Api
  module V1

    def self.slug(name)
      I18n.transliterate(name).downcase.gsub(". ", "-").gsub(".","-").gsub(" ","-")
    end

    player_data = [
      {name: "Marcelo Almeida", team:	"Camisa10daGavea"},
      {name: "José Carlos", team:	"Boa Viagem E. Clube"},
      {name: "Bruno Dias", team:	"Valério Central F. C"},
      {name: "Alberto Perdigão", team:	"PerdiCartola F.C"},
      {name: "Fabio Gurgel", team:	"FaBayern FC"},
      {name: "Cleber Ramos", team:	"47 DO SEGUNDO TEMPO FC"},
      {name: "Felipe Phelype", team:	"IslandOfCatsFootball"},
      {name: "Rennan Batista", team:	"Chico e Gunha FC"},
      {name: "Lucas Batista", team:	"vovo S.C"},
      {name: "Cayo Luiz", team:	"C.Luiz"},
      {name: "Ronilson Costa", team:	"Phode Chorarr FC"},
      {name: "Caio Batista", team:	"Batista S.C"},
      {name: "Rafael Costa", team:	"Ferrim Saint-Germain"},
      {name: "Márcio Ayres", team:	"Down Futball United"},
      {name: "Daniel Oliveira", team:	"PIEDADE FCF"},
      {name: "Victor Gomes", team:	"Victor Gomes CSC"},
      {name: "Vanduy Sales", team:	"Vanduka FC"},
      {name: "Victor Santiago", team:	"VBSantiago FC"},
      {name: "Leonardo Brandão", team:	"Guerreiros do Vila"},
      {name: "Marcelo Faustino", team:	"Palestra Cangaceiro"},
      {name: "Vanderson Cabral", team:	"FC Cara Seca"},
      {name: "Vladimir Gomes", team:	"Emilly Acsa FC"},
      {name: "Danielson Filho", team:	"Raimundões FC"},
      {name: "Marciano Araújo", team:	"Cearabarça FC"},
      {name: "Reginaldo Ramos", team:	"Hr Premoldados"},
      {name: "Emival Queiroz", team:	"Emival SCCP"},
      {name: "Matheus Batista", team:	"orlof F.C"},
      {name: "Felipe Martins", team:	"Cearamor Messejana"},
      {name: "Felipe Batista", team:	"Cachagol FC"},
      {name: "Renan Benevides", team:	"simple man"},
      {name: "JORGE PEREIRA", team:	"CARAI DEMAIS"},
      # {name: " Daniel Djimis", team: ""}
    ]

    season = Season.last
    season = Season.create(year: Time.now.year, golden_rounds: [1,5,9,14,17,24,27,32,38]) if season.nil?
    DisputeMonth.create(name: "Maio/Junho", season: season, dispute_rounds: (1..10).to_a )
    DisputeMonth.create(name: "Julho", season: season, dispute_rounds: (11..17).to_a )
    DisputeMonth.create(name: "Agosto", season: season, dispute_rounds: (18..22).to_a )
    DisputeMonth.create(name: "Setembro", season: season, dispute_rounds: (23..26).to_a )
    DisputeMonth.create(name: "Outubro", season: season, dispute_rounds: (27..31).to_a )
    DisputeMonth.create(name: "Novembro", season: season, dispute_rounds: (32..38).to_a )

    player_data.each do |data|
      p = Player.new(name: data[:name])
      p.teams << Team.new(name: data[:team], season: season, slug: slug(data[:team]))
      p.save
    end

    # Filling rounds

    # season = Api::V1::Season.last
    # (1..26).to_a.each do |number|
    #   round = Api::V1::Round.find{|r| r.season.id == season.id and r.number == number}
    #   if round.nil?
    #     ## verify if its golden (on seasons)
    #     golden = season.golden_rounds.include?(number)
    #     ## verify dispute month (if configured )
    #     dispute = Api::V1::DisputeMonth.find{|d| d.season_id == season.id and d.dispute_rounds.include?(number)}
    #     round = Api::V1::Round.create(number: number, season: season, dispute_month: dispute, golden: golden, finished: false)
    #   end
    # end
  end
end
