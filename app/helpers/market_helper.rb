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
      ['Phù hợp nhất', 'relevance'],
      ['Mới nhất', 'created_atdesc'],
      ['Cũ nhất', 'created_atasc'],
      ['Giá: Thấp đến cao', 'priceasc'],
      ['Giá: Cao đến thấp', 'pricedesc']
    ], params[:sort] || "relevance")
  end
end
