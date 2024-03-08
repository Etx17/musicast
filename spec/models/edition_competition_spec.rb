require 'rails_helper'

RSpec.describe EditionCompetition, type: :model do
  # describe "Factory" do
  #   it "is successfully created" do
  #     expect(create(:edition_competition)).to be_valid
  #   end
  # end

  describe "Scope published_and_upcoming" do
    let(:edition_competition) { create(:edition_competition, :published) }
    let(:past_edition_competition) { create(:edition_competition, :published, :past) }
    it "returns only editions in the future" do
      expect(EditionCompetition.published_and_upcoming).to include(edition_competition)
      expect(EditionCompetition.published_and_upcoming).to_not include(past_edition_competition)
    end

    it "returns only published editions" do
      edition_competition.update(status: "draft")
      expect(EditionCompetition.published_and_upcoming).to_not include(edition_competition)
    end

  end
end
