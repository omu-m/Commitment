class Public::CommentsController < ApplicationController
  
  def create
    @subtask = Subtask.find(params[:subtask_id])
    @comment = @subtask.comments.new(comment_params)
    @comment.member_id = current_member.id
    if @comment.save
      flash.now[:notice] = "コメントの投稿に成功しました。"
      #render先にjsファイルを指定
      render "subtask_comments"
    else
      flash.now[:notice] ="コメントの投稿に失敗しました。"
      #render先にjsファイルを指定
      render "error"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash.now[:notice] = "コメントを削除しました。"
    #render先にjsファイルを指定
    render "subtask_comments"
  end
end
