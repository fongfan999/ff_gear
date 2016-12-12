module MarketHelper
  def category_nav(category = nil)
    if category.nil?
      icon =  material_icon_of("home")
      name = "Trang chủ"
    else
      icon =  material_icon_of(category.icon)
      name = category.name
    end
    
    icon + 
      ("<span class='hide-on-med-and-down'>#{name}<span>").html_safe
  end

  def options_from_collection_for_sorting
    options_for_select([
      ['Phù hợp nhất', 'relevance'],
      ['Mới nhất', 'created_atdesc'],
      ['Cũ nhất', 'created_atasc'],
      ['Giá: Thấp đến cao', 'priceasc'],
      ['Giá: Cao đến thấp', 'pricedesc']
    ],
      params[:sort] || 
      (params[:filter] && params[:filter][:sort]) || 
      "relevance"
    )
  end
end
