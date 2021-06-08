class Mutations::Dispute::Edit < GraphQL::Schema::Mutation
  null false

  argument :id, Integer, required: true
  argument :name, String, required: true

  def resolve(id: Integer!, name: String!)
    dispute = DisputeMonth.find(id)
    raise 'Mês de disputa não encontrado' if dispute.nil?

    raise 'Mês de disputa não pode mais ser editado.' unless dispute.status == 'created'

    dispute.update(name: name)
    dispute
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end