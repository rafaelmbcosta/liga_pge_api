class Mutations::Dispute::SetDisputeToRound < GraphQL::Schema::Mutation
  description "set a round to a mutation"

  null false

  argument :id, Integer, required: true
  argument :round_id, Integer, required: true

  def resolve(id: Integer!, round_id: Integer!)
    round = Round.find(round_id)
    dispute = DisputeMonth.find(id)
    raise 'Nenhum mês de disputa encontrado' if dispute.nil?

    raise 'Temporada já finalizada' if  dispute.finished
    round.update(dispute_month: dispute)
    round
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
