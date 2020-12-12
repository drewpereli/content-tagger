# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :ensure_authenticated_user

  def create
    @user = User.create(create_params)
    if @user.valid?
      token = @user.token
      render json: {user: user_json, token: token}, status: :created
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: login_params[:email])

    if @user&.authenticate(login_params[:password])
      token = @user.token
      render json: {user: user_json, token: token}
    else
      render json: {errors: "Invalid email or password"}, status: :unauthorized
    end
  end

  private

  def user_json
    return unless @user

    {id: @user.id, email: @user.email}
  end

  def create_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def login_params
    params.permit(:email, :password)
  end
end
