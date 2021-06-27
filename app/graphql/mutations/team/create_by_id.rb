class Mutations::Team::CreateById < GraphQL::Schema::Mutation
  description 'Create Team by id'

  argument :team_id, Integer, required: true

  def resolve(team_id: Integer)
    team = Team.create(id_tag: team_id)
    raise team.errors.messages.values.join(', ') if team.errors.any?

    TeamWorker.perform
    team
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
