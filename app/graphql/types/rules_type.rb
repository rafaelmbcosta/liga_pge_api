module Types
  class RulesType < Types::BaseObject
    field :id, ID, null: true
    field :text, String, null: false
  end
end