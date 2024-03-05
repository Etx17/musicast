require 'rails_helper'

RSpec.describe Tour, type: :model do
  describe "Factory" do
    it "is successfully created" do
      expect(create(:tour)).to be_valid
    end
  end
end
