require 'rails_helper'

RSpec.describe Inscription, type: :model do
  describe "Factory" do
    it "is successfully created" do
      expect(create(:inscription)).to be_valid
    end
  end
end
