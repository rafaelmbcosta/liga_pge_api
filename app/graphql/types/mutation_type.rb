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

    field :save_rules, RulesType, null: false, description: "Creating a new Rule" do
      argument :text, String, required: true
    end

    def save_rules(text: String)
      Rule.create(text: text)
    rescue StandardError => e
      raise e.message
    end

    field :create_dispute, DisputeType, null: false, description: "Creating Dispute" do
      argument :name, String, required: true
    end

    def create_dispute(name: String!)
      season = Season.active
      raise "Temporada precisa ser criada !" if season.nil?

      DisputeMonth.create!(season: season, name: name)
    end
  end
end
