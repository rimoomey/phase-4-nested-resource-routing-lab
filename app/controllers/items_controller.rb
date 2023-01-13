class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user, status: :ok
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item, include: :user, status: :ok
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = Item.create(item_params)
      user.items << item
    else
      item = Item.create(item_params)
    end
    render json: item, include: :user, status: :created
  end

  private

  def item_params
    params.permit :name, :description, :price, :user_id
  end

  def render_not_found_response
    render json: { error: 'User not found' }, status: :not_found
  end
end
