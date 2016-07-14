class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :picture_url, :number, :parent_category

  has_many :categories

  def parent_category
    if object.category_id.present?
      {
        id: object.category.id,
        title: object.category.title
      }
    end
  end

  def picture_url
    object.picture_url if object.image.sub("#{object.id}-", '').present?
  end
end
