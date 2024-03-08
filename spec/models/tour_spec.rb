require 'rails_helper'

RSpec.describe Tour, type: :model do
  describe "Factory" do
    it "is successfully created" do
      expect(create(:tour)).to be_valid
    end
  end

  describe "#next_tour" do
    let(:category) { create(:category) }
    it "returns the correct next tour" do
      tour = category.tours.first
      tour.update(is_finished: true)
      tour2 = category.tours.first(2).last
      expect(tour.next_tour).to eq(tour2)
    end
  end
end
