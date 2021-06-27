class Mutations::Dispute::Delete < GraphQL::Schema::Mutation
  null false

  argument :id, Integer, required: true

  def resolve(id: Integer!)
    dispute = DisputeMonth.find(id)
    raise 'Mês de disputa não encontrado' if dispute.nil?

    raise 'Remova as rodadas antes de deletar!' if dispute.rounds.any?

    raise 'Mês de disputa não pode mais ser deletada.' unless dispute.status == 'created'

    dispute.destroy
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end