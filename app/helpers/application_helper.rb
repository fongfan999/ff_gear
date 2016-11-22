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

  def login_button(image, provider)
    image_tag(image) + "<span>Đăng nhập bằng #{provider}</span>".html_safe
  end
end
