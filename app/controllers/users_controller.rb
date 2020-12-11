# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid email or password"}
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid email or password"}
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end