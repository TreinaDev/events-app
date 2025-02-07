class KeywordsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_admin
  add_breadcrumb "Home", :dashboard_path

  def new
    @keyword = Keyword.new

    add_breadcrumb "Categorias", :categories_path
    add_breadcrumb "Cadastrar Palavra-Chave"
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      redirect_to categories_path, notice: t(".success", keyword: @keyword.value)
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def keyword_params
    params.require(:keyword).permit(:value)
  end
end
