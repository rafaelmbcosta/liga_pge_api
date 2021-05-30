module Types
  class TeamType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :active, Boolean, null: true
    field :id_tag, Integer, null: false
    field :url_escudo_png, String, null: true
    field :player_name, String, null: true
  end
end