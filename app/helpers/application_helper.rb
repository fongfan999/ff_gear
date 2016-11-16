module ApplicationHelper
  def fetch_html_options(html_options = {})
    # Listing html_options
    options = %i{ id class }

    # Initalize hash 
    options_hash = {}

    # Assign value from html_options to options_hash or empty string
    options.each do |attr|
      options_hash[attr] = html_options.key?(attr) ? html_options[attr] : ""
    end

    # Return function as options_hash
    options_hash
  end

  def material_icon_of(icon_name = "", html_options = {})

    # Get value from html_options
    options = fetch_html_options(html_options)

    options[:name] = html_options.key?(:name) ? html_options[:name] : ""

    "
      <i id='#{options[:id]}' class='material-icons #{options[:class]}'>
        #{icon_name}
      </i>
      #{options[:name]}
    ".html_safe
  end

  def date_or_time_ago_in_words(date, include_second = false)
    if Time.now - 1.week > date
      if include_second
        date.strftime("%d - %m - %Y lúc %H:%M:%S")
      else
        date.strftime("%d - %m - %Y")
      end
      
    else
      time_ago_in_words(date)
    end
  end
end
