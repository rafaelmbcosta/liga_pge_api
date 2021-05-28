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

    field :create_team_by_id, TeamType, null: false, description: "Create Team by id" do
      argument :team_id, Integer, required: true
    end 
   
    def create_team_by_id(team_id: Integer)
      team = Team.create(id_tag: team_id)
      TeamWorker.perform
      team
    end
    
    field :active, TeamType, null: false, description: 'Active or inactive on Team' do
      argument :team_id, Integer, required: true
      argument :active, Boolean, required: true
    end
     
    def active(team_id: Integer, active: Boolean)
      team = Team.find(team_id)
      team.update(active: active)
      team
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
      Season.new_season
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
