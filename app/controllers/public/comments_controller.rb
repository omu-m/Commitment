class Public::CommentsController < ApplicationController

  before_action :authenticate_member!

  def create
    @subtask = Subtask.find(params[:subtask_id])
    @comment = @subtask.comments.new(comment_params)
    @comment.member_id = current_member.id
    @comment_reply = @subtask.comments.new
    @comments = @subtask.comments.order(created_at: :desc)
    if @comment.save
      @comment.create_activities(@comment, "comment", current_member.id, @subtask.member_id)
      flash.now[:notice] = "コメントの投稿に成功しました。"
    else
      flash.now[:alert] ="コメントの投稿に失敗しました。"
    end
  end

  def destroy
    @subtask = Subtask.find(params[:subtask_id])
    @comment_reply = @subtask.comments.new
    @comment = current_member.comments.find_by(id: params[:id])
    if @comment.present?
      if params[:reply_id].present?
        #replyの削除
        Comment.find(params[:reply_id]).destroy
        flash.now[:alert] = "リプライを削除しました。"
      else
        #コメントの削除
        @comment.destroy
        flash.now[:alert] = "コメントを削除しました。"
      end
    else
      flash.now[:alert] = "削除出来ませんでした。"
    end
    @subtask = Subtask.find(params[:subtask_id])
    @comments = @subtask.comments.order(created_at: :desc)
  end

  private

  def comment_params
    params.permit(:comment, :subtask_id, :parent_id)
  end
end
