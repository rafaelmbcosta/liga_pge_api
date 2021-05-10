module Types
  class MutationType < Types::BaseObject

    field :login, String, null: true, description: 'User Login' do
      argument :email, String, required: true
      argument :password, String, required: true
    end

    def login(email: String, password: String)
      if user = User.where(email: email).first&.authenticate(password)
        user.sessions.create.key
      end
    end

    field :logout, Boolean, null: false

    def logout
      Session.where(id: context[:session_id]).destroy_all
      true
    end

    field :create_season, SeasonType, null: true, description: "Create Season" do
      argument :year, Integer, required: false
    end

    def create_season(year: Integer)
      # raise 'Unauthorized' if !context[:current_user]

      Season.create!
    rescue StandardError => e
      raise e.message
    end

    field :create_dispute, DisputeType, null: false, description: "Creating Dispute" do
      argument :name, String, required: true
    end

    def create_dispute(**args)
      season = Season.active
      raise "Temporada precisa ser criada !" if season.nil?

      dispute = nil
      ActiveRecord::Base.transaction do
        dispute = Dispute.create!(season: season, name: args[:name], order: Dispute.next_order)
        Rails.logger.info(dispute.inspect)
        if args[:rounds]
          collection = Round.where(id: args[:rounds])
          collection.update_all(dispute_id: dispute.id)
        end
      end
      dispute
    end
  end
end
