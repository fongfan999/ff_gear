module MarketHelper
  def category_nav(name)
    icon =  case name
    when 'Tai nghe'
      '<i class="material-icons left">headset</i>'
    when 'Bàn phím'
      '<i class="material-icons left">keyboard</i>'
    when 'Chuột'
      '<i class="material-icons left">mouse</i>'
    else
      '<i class="material-icons left">devices_other</i>'
    end

    (icon + "<span class='hide-on-med-and-down'> #{name}<span>").html_safe
  end
end
