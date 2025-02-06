class CategoriesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_admin
  add_breadcrumb "Home", :dashboard_path

  def index
    @categories = Category.all

    add_breadcrumb "Categorias"
  end

  def new
    @category = Category.new

    add_breadcrumb "Categorias", :categories_path
    add_breadcrumb "Nova Categoria"
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

    add_breadcrumb "Categorias", :categories_path
    add_breadcrumb "#{@category.name}"
  end

  def update
    @category = Category.find(params[:id])
    redirect_to categories_path, notice: t(".success") if @category.update(category_params)
  end

  private

  def category_params
    params.require(:category).permit(:name, keyword_ids: [])
  end
end
