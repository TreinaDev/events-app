class CategoriesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_admin

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find(params[:id])
    @linked_keyword_ids = @category.keywords.ids
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, keyword_ids: [])
  end
end
