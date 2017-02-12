require "rails_helper"

RSpec.describe Season, :type => :model do

  describe "Validations" do
    it { should validate_presence_of(:year) }
  end

end
