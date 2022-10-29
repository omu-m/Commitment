class Public::HomesController < ApplicationController

  before_action :authenticate_member!

  def top
  end

  def about
  end
end
