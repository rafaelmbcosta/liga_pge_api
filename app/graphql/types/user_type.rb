module Types
  class UserType < Types::BaseObject
    field :id, ID, null: true
    field :email, String, null: true
    field :is_superadmin, Boolean, null: true, camelize: false

    def self.visible?(context)
      !!context[:current_user]
    end
  end
end