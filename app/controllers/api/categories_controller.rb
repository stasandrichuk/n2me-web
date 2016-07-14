class Api::CategoriesController < Api::BaseController
  def index
    categories = Category.includes(:category, :categories)
                         .order('categories.order DESC')
                         .page(page)
                         .per(per_page)
    render json: categories, meta: pagination_dict(categories)
  end

  def show
    category = Category.where('id = :id OR number = :id', id: params[:id])
    if category.present?
      render json: category
    else
      render json: { errors: 'Category not found' }, status: 404
    end
  end
end
