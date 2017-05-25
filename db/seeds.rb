# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
season = FactoryGirl.create(:v1_season)
players = FactoryGirl.create_list(:v1_player, 50 )
players.each do |player|
  FactoryGirl.create(:v1_team, player: player, season: season)
end
