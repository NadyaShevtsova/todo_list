class AttachmentsController < ApplicationController

  def create
    attachment = Attachment.new(attachment_params)
    if attachment.save
      render json: { attachment: attachment.to_jq_uploader }, status: 201
    else
      render json: { errors: attachment.errors }, status: 422
    end
  end

  def destroy
    attachment = Attachment.find(params[:id])
    if attachment.destroy
      render json: { id: attachment.id }, status: 200
    else
      render json: { errors: attachment.errors }, status: 422
    end
  end



  private
  def attachment_params
    { file: params[:file] }
  end

end
