# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/tags", type: :request do
  let(:response_body) { JSON.parse(response.body) }

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  let(:valid_attributes) do
    {name: "foobar"}
  end

  let(:invalid_attributes) do
    {name: nil}
  end

  let(:valid_headers) do
    {"Authorization" => "Bearer #{user.token}"}
  end

  describe "GET /index" do
    let!(:user_tag_1) { create(:tag, user: user) }
    let!(:user_tag_2) { create(:tag, user: user) }
    let!(:other_user_tag) { create(:tag, user: other_user) }

    before { get tags_url, headers: valid_headers, as: :json }

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "only returns the user's tags" do
      expect(response_body["tags"]).to eql([
        {"id" => user_tag_1.id, "name" => user_tag_1.name},
        {"id" => user_tag_2.id, "name" => user_tag_2.name}
      ])
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:post_create) { post tags_url, params: {tag: valid_attributes}, headers: valid_headers, as: :json }

      it "creates a new Tag" do
        expect { post_create }.to change(Tag, :count).by(1)
      end

      it "renders a JSON response with the new tag" do
        post_create
        expect(response).to have_http_status(:created)
        expect(response_body["tag"].keys).to eql(%w[id name])
      end
    end

    context "with invalid parameters" do
      let(:post_create) { post tags_url, params: {tag: invalid_attributes}, headers: valid_headers, as: :json }

      it "does not create a new Tag" do
        expect { post_create }.to change(Tag, :count).by(0)
      end

      it "renders a JSON response with errors for the new tag" do
        post_create
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {name: "my new name"}
      end

      it "updates the requested tag" do
        tag = Tag.create!(name: "my old name", user: user)
        patch tag_url(tag),
              params: {tag: new_attributes}, headers: valid_headers, as: :json
        tag.reload
        expect(tag.name).to eql("my new name")
      end

      it "renders a JSON response with the tag" do
        tag = Tag.create!(name: "my old name", user: user)
        patch tag_url(tag),
              params: {tag: new_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the tag" do
        tag = Tag.create!(name: "my old name", user: user)
        patch tag_url(tag),
              params: {tag: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested tag" do
      tag = Tag.create!(name: "my name", user: user)
      expect do
        delete tag_url(tag), headers: valid_headers, as: :json
      end.to change(Tag, :count).by(-1)
    end
  end
end
