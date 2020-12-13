# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemPolicy, type: :policy do
  subject(:policy) { described_class }

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  permissions ".scope" do
    let(:scope) { ItemPolicy::Scope.new(user, Item) }
    let!(:user_item_1) { create(:item, user: user) }
    let!(:user_item_2) { create(:item, user: user) }
    let!(:other_user_item_1) { create(:item, user: other_user) }
    let!(:other_user_item_2) { create(:item, user: other_user) }

    it "only returns the user's items" do
      expect(scope.resolve.pluck(:id)).to match_array([user_item_1.id, user_item_2.id])
    end
  end

  permissions :create? do
    it "authorizes any user" do
      expect(policy).to permit(user)
      expect(policy).to permit(other_user)
    end
  end

  # permissions :update? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  permissions :destroy? do
    let(:item) { create(:item, user: user) }

    it "only permits the item owner" do
      expect(policy).to permit(user, item)
      expect(policy).not_to permit(other_user, item)
    end
  end
end
