class Admin::PostsController < Admin::ApplicationController
  def index
    @posts = Post.search(params[:q]).paginate(page: params[:page])
  end

  def show_chart
    respond_to do |format|
      format.js
    end
  end
end
