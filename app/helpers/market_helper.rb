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
end
