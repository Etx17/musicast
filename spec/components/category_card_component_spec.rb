# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryCardComponent, type: :component do
  let(:category) { create(:category) }
  subject { described_class.new(category: category) }

  it "renders the category name" do
    expect(render_inline(subject).to_html).to include(category.name)
  end
end
