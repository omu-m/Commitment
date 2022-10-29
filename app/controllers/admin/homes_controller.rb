class Admin::HomesController < ApplicationController

  before_action :authenticate_admin!

  def top
    @members = Member.all
    all_member = @members.count
    invalid_member = @members.where(is_deleted: true).count
    valid_member = @members.where(is_deleted: false).count
    if invalid_member == 0
      @withdrawal_rate = 0
    elsif valid_member == 0
      @withdrawal_rate = 0
    else
      @withdrawal_rate = ((invalid_member*100)/all_member).floor
    end

    @tasks = Task.all
    @subtasks = Subtask.all
    @comments = Comment.all
  end
end
