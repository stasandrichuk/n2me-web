module ApplicationHelper
  def define_columns_count(items_number)
    return 6 if items_number % 6 == 0
    return 5 if items_number % 5 == 0
    return 4 if items_number % 4 == 0
    5
  end

  def slide_item_number
    case request.variant.first
    when :tablet
      3
    when :phone
      2
    else
      4
    end
  end
end
