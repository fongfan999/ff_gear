module MarketHelper
  def category_nav(name)
    icon =  case name
    when 'Tai nghe'
      '<i class="material-icons">headset</i>'
    when 'Bàn phím'
      '<i class="material-icons">keyboard</i>'
    when 'Chuột'
      '<i class="material-icons">mouse</i>'
    when 'Khác'
      '<i class="material-icons">devices_other</i>'
    else
      '<i class="material-icons">home</i>'
    end

    (icon + "<span class='hide-on-med-and-down'> #{name}<span>").html_safe
  end
end
