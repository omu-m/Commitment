class Public::CommentsController < ApplicationController

  def create
    @subtask = Subtask.find(params[:subtask_id])
    @comment = @subtask.comments.new(comment_params)
    @comment.member_id = current_member.id
    @comment_reply = @subtask.comments.new
    @comments = @subtask.comments.order(created_at: :desc)
    if @comment.save
      flash.now[:notice] = "コメントの投稿に成功しました。"
    else
      flash.now[:notice] ="コメントの投稿に失敗しました。"
    end
  end

  def destroy
    @subtask = Subtask.find(params[:subtask_id])
    @comment_reply = @subtask.comments.new
    @comment = current_member.comments.find_by(id: params[:id])
    if @comment.present?
      @comment.destroy
      flash.now[:notice] = "コメントを削除しました。"
    else
      flash.now[:notice] = "コメントを削除出来ませんでした。"
    end
    @subtask = Subtask.find(params[:subtask_id])
    @comments = @subtask.comments.order(created_at: :desc)
  end

  private

  def comment_params
    params.permit(:comment, :subtask_id, :parent_id)
  end
end
