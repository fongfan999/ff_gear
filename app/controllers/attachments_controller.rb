class AttachmentsController < ApplicationController
  def upload
  end

  def create
    @attachment = Attachment.create(file: params[:file])
    render json: @attachment
  end
end
