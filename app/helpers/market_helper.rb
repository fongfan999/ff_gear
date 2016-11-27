module MarketHelper
  def category_nav(name)
    icon =  case name
    when 'Tai nghe'
      material_icon_of "headset"
    when 'Bàn phím'
      material_icon_of "keyboard"
    when 'Chuột'
      material_icon_of "mouse"
    when 'Khác'
      material_icon_of "devices_other"
    else
      material_icon_of "home"
    end

    icon + ("<span class='hide-on-med-and-down'>#{name}<span>").html_safe
  end

  def options_from_collection_for_sorting
    options_for_select([
      ['Liên quan', 'location_asc'],
      ['Mới nhất', 'created_desc'],
      ['Cũ nhất', 'created_asc'],
      ['Giá: Thấp đến cao', 'price_asc'],
      ['Giá: Cao đến thấp', 'price_desc']
    ])
  end
end
