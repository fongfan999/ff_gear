module MainHelper
  def category_checked?(category)
    return true if params[:filter].blank? || params[:filter].fetch(:category_ids, nil).nil?

    params[:filter][:category_ids].include?(category.id.to_s)
  end
end
