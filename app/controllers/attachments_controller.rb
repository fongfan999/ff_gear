class AttachmentsController < ApplicationController
  def upload
  end

  def create
    @attachment = Attachment.create(file: params[:file])
    attachment_ids = session[:attachment_ids] || []
    attachment_ids << @attachment.id
    session[:attachment_ids] = attachment_ids
    render json: @attachment
  end
end
