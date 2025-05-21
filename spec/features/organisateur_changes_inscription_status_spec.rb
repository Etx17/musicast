require 'rails_helper'

RSpec.feature "Organisateur changes candidate status", type: :feature do
  let(:inscription) { FactoryBot.create(:inscription, :in_review) }
  let(:category) { inscription.category }
  let(:edition_competition) { category.edition_competition }
  let(:competition) { edition_competition.competition }
  let(:organism) { competition.organism }
  let(:organisateur) { inscription.category.edition_competition.competition.organism.organisateur }
  let(:candidate) { inscription.candidat }
  scenario "Organisateur accepts an inscription and it moves it to the right column" do
    visit new_user_session_path
    fill_in "Email", with: organisateur.user.email
    fill_in "Mot de passe", with: organisateur.user.password
    click_button "Se connecter"

    visit organism_competition_edition_competition_category_inscriptions_path(organism_id: organism.id, competition_id: competition.id, edition_competition_id: edition_competition.id, category_id: category.id)

    click_button "Accept"

    expect(inscription.reload.status).to eq("accepted")

    within("#accepted") do
      expect(page).to have_content(inscription.candidat.full_name)
    end
  end
end
