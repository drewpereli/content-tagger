# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tag, type: :model do
  let(:user) { create(:user) }

  describe ".create" do
    let(:create_tag) { described_class.create(params) }

    shared_examples "a failed create" do
      it "fails" do
        expect { create_tag }.to change(described_class, :count).by(0)
        expect(create_tag).not_to be_valid
      end
    end

    context "when name is missing" do
      let(:params) { {name: nil, user: user} }

      it_behaves_like "a failed create"
    end

    context "when user is missing" do
      let(:params) { {name: "foo bar", user: nil} }

      it_behaves_like "a failed create"
    end

    context "when name is too long" do
      let(:params) { {name: "a" * 31, user: user} }

      it_behaves_like "a failed create"
    end

    context "when params are valid" do
      let(:params) { {user: user, name: "a" * 30} }

      it "succeeds" do
        expect { create_tag }.to change(described_class, :count).by(1)
        expect(create_tag).to be_valid
      end
    end
  end
end
