class CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    comment.user = current_user

    if comment.save
      render json: { comment: comment }, status: 201
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      render json: { success: "Comment was successfully destroyed.", id: comment.id }, status: 200
    else
      render json: { error: comment.errors.full_messages.to_sentence }, status: 422
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :comment, :commentable_id, :commentable_type)
  end
end
