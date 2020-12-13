# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagPolicy, type: :policy do
  subject(:policy) { described_class }

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  permissions ".scope" do
    let(:scope) { TagPolicy::Scope.new(user, Tag) }
    let!(:user_tag_1) { create(:tag, user: user) }
    let!(:user_tag_2) { create(:tag, user: user) }
    let!(:other_user_tag_1) { create(:tag, user: other_user) }
    let!(:other_user_tag_2) { create(:tag, user: other_user) }

    it "only returns the user's tags" do
      expect(scope.resolve.pluck(:id)).to match_array([user_tag_1.id, user_tag_2.id])
    end
  end

  permissions :create? do
    it "authorizes any user" do
      expect(policy).to permit(user)
      expect(policy).to permit(other_user)
    end
  end

  permissions :update?, :destroy? do
    let(:tag) { create(:tag, user: user) }

    it "only permits the tag owner" do
      expect(policy).to permit(user, tag)
      expect(policy).not_to permit(other_user, tag)
    end
  end
end
