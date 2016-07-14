class MediumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :number, :source_url,
             :extra_sources, :language, :rating, :order, :embedded_code,
             :overlay_code, :created_at, :updated_at, :image, :pricing_plan_id,
             :is_a_game, :medium_id, :picture_url, :language_list, :categories

  def categories
    object.categories.map { |cat| { id: cat.id, title: cat.title } }
  end

  def picture_url
    object.picture_url if object.image.sub("#{object.id}-", '').present?
  end
end
