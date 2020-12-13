# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/items", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_headers) { {"Authorization" => "Bearer #{user.token}"} }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /index" do
    let!(:user_item_1) { create(:item, content: "u1 foo", user: user) }
    let!(:user_item_2) { create(:item, content: "u1 bar", user: user) }
    let!(:other_user_item_1) { create(:item, content: "u2 foo", user: other_user) }
    let!(:other_user_item_2) { create(:item, content: "u2 bar", user: other_user) }

    before { get "/items", headers: valid_headers, as: :json }

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "returns the items belonging to the user" do
      expect(response_body["items"].length).to be(2)

      expect(response_body["items"][0].slice("id", "content")).to eql({
        "id" => user_item_1.id,
        "content" => "u1 foo"
      })

      expect(response_body["items"][1].slice("id", "content")).to eql({
        "id" => user_item_2.id,
        "content" => "u1 bar"
      })
    end

    # it "renders a successful response" do
    #   Item.create! valid_attributes
    #   get items_url, headers: valid_headers, as: :json
    #   expect(response).to be_successful
    # end
  end

  describe "POST /create" do
    let(:post_create) { post "/items", params: {item: params}, headers: valid_headers, as: :json }

    context "with valid parameters" do
      let(:params) { {content: "foo"} }

      it "creates a new Item" do
        expect { post_create }.to change(Item, :count).by(1)
      end

      it "renders a JSON response with the new item" do
        post_create
        expect(response).to have_http_status(:created)

        item = Item.first
        expect(response_body["item"]).to eql({"id" => item.id, "content" => item.content, "content_type" => item.content_type})
      end
    end

    context "with invalid parameters" do
      let(:params) { {foo: "bar"} }

      it "does not create a new Item" do
        expect { post_create }.to change(Item, :count).by(0)
      end

      it "renders a JSON response with errors for the new item" do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) do
  #       skip("Add a hash of attributes valid for your model")
  #     end

  #     it "updates the requested item" do
  #       item = Item.create! valid_attributes
  #       patch item_url(item),
  #             params: {item: invalid_attributes}, headers: valid_headers, as: :json
  #       item.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the item" do
  #       item = Item.create! valid_attributes
  #       patch item_url(item),
  #             params: {item: invalid_attributes}, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to eq("application/json")
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a JSON response with errors for the item" do
  #       item = Item.create! valid_attributes
  #       patch item_url(item),
  #             params: {item: invalid_attributes}, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to eq("application/json")
  #     end
  #   end
  # end

  describe "DELETE /destroy" do
    let(:delete_destroy) { delete "/items/#{item.id}", headers: valid_headers, as: :json }
    let!(:item) { create(:item, user: user) }

    it "destroys the requested item" do
      expect { delete_destroy }.to change(Item, :count).by(-1)
    end
  end
end
