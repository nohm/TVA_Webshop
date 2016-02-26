class CategoriesController < ApplicationController
	def index
    @categories = Category.all.page(params[:page]).per(25).order('product_id ASC')
  end

	def new
		@category = Category.new
	end

	def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
      flash[:success] = "Category added"
    else
      render 'new'
  	end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to categories_path
    flash[:success] = "Category deleted"
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path
      flash[:success] = "Category updated"
    else
      render 'edit'
    end
  end
  
  private

	def category_params
	  params.require(:category).permit(:product_id, :name)
	end
end
