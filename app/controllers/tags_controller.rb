# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: %i[show update destroy]

  # GET /tags
  def index
    @tags = policy_scope(Tag)

    render json: @tags
  end

  # POST /tags
  def create
    authorize(Tag)

    @tag = Tag.new(tag_params.merge(user: current_user))

    if @tag.save
      render json: @tag, status: :created, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    authorize(@tag)

    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    authorize(@tag)

    @tag.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def tag_params
    params.require(:tag).permit(:name)
  end
end
