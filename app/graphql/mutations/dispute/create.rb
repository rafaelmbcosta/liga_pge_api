class Mutations::Dispute::Create < GraphQL::Schema::Mutation
  description "Creating Dispute"

  null false

  argument :name, String, required: true

  def resolve(name: String!)
    season = Season.active
    raise "Temporada precisa ser criada !" if season.blank?

    DisputeMonth.create!(season: season, name: name)
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
