class Mutations::Dispute::RemoveDisputeFromRound < GraphQL::Schema::Mutation
  description 'removes a dispute from round'

  null false

  argument :id, Integer, required: true

  def resolve(id: Integer!)
    round = Round.find(id)
    round.update(dispute_month: nil)
    round
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
