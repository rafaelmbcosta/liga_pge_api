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
    teams_hash = [
      {
        "id": 1,
        "name": "Ferrimbahçe",
        "player_name": "Rafael Fera",
        "active": true,
        "url_escudo_png": "https://s2.glbimg.com/_PR4nkr2W4gsrtRk3lKHIUnVLeY=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939"
      },
      {
        "id": 2,
        "name": "Ferrim Saint-germain",
        "player_name": "Rafael Fera",
        "active": false,
        "url_escudo_png": "https://s2.glbimg.com/_PR4nkr2W4gsrtRk3lKHIUnVLeY=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939"
      },
      {
        "id": 3,
        "name": "Down Futball United",
        "player_name": "Marcio Down",
        "active": true,
        "url_escudo_png": "https://s2.glbimg.com/4mh8qoPb38V76c9kk3t6OXvBY3s=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_133/escudo/f6/33/49/00151931e3-86f4-49ed-b201-bd9416a02af620190402153349"
      },
      {
        "id": 4,
        "name": "Fabayern FC",
        "player_name": "Fabio Teimoso da Silva",
        "active": true,
        "url_escudo_png": "https://s2.glbimg.com/qusjYptboVNjNOslNc55fZEAyJQ=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_108/escudo/62/39/50/0067cbf8fd-a20c-499e-bef5-f0f5c0ce5b6220180411153950"
      }
    ]

    teams_hash.each do |team|
      Team.create(team.reject { |t| t['id'] })
    end
  end
end
