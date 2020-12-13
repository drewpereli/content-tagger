# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: %i[update destroy]

  # GET /items
  def index
    @items = Item.where(user: current_user)
    render json: @items
  end

  # POST /items
  def create
    @item = Item.new(item_params.merge(user: current_user))

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  # def update
  #   if @item.update(item_params)
  #     render json: @item
  #   else
  #     render json: @item.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /items/1
  def destroy
    if @item.destroy
      head :no_content
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:content, :content_type)
  end
end
