# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST users" do
    let(:post_users) { post "/users", params: params }
    let(:parsed_body) { JSON.parse(response.body) }

    context "when the params are valid" do
      let(:params) { {email: "me@gmail.com", password: "Password123", password_confirmation: "Password123"} }

      before { post_users }

      it "responds with a 201" do expect(response.status).to be(201) end
      it "creates a user" do expect(User.count).to be(1) end

      it "returns a token" do expect(parsed_body["token"]).to be_truthy end

      it "returns the user correct user attributes" do
        expect(parsed_body["user"]).to eql({"id" => User.find_by(email: "me@gmail.com").id, "email" => "me@gmail.com"})
      end
    end

    context "when passwords don't match" do
      let(:params) { {email: "me@gmail.com", password: "Password123", password_confirmation: "Password1234"} }

      before { post_users }

      it "responds with a 422" do expect(response.status).to be(422) end
      it "doesn't create a user" do expect(User.count).to be(0) end
    end

    context "when email is already taken" do
      let(:params) { {email: "me@gmail.com", password: "Password123", password_confirmation: "Password123"} }

      before do
        User.create!(params)
        post_users
      end

      it "responds with a 422" do expect(response.status).to be(422) end
      it "doesn't create a user" do expect(User.count).to be(1) end
    end
  end

  describe "POST login" do
    let(:post_login) { post "/login", params: params }
    let(:parsed_body) { JSON.parse(response.body) }

    let!(:user) { User.create(email: "me@gmail.com", password: "Password123", password_confirmation: "Password123") }

    context "when the email and password are correct" do
      let(:params) { {email: "me@gmail.com", password: "Password123"} }

      before { post_login }

      it "returns a token" do expect(parsed_body["token"]).to be_truthy end

      it "returns the user correct user attributes" do
        expect(parsed_body["user"]).to eql({"id" => user.id, "email" => "me@gmail.com"})
      end
    end

    context "when the email is incorrect" do
      let(:params) { {email: "i.dont.exist@gmail.com", password: "Password123"} }

      before { post_login }

      it "returns a 422" do expect(response.status).to be(401) end
      it "returns an error message" do expect(parsed_body["errors"]).to eql("Invalid email or password") end
    end

    context "when the password is incorrect" do
      let(:params) { {email: "me@gmail.com", password: "IncorrectPassword"} }

      before { post_login }

      it "returns a 422" do expect(response.status).to be(401) end
      it "returns an error message" do expect(parsed_body["errors"]).to eql("Invalid email or password") end
    end
  end
end
