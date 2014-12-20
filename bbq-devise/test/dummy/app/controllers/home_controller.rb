class HomeController < ApplicationController

  def index
    authenticate_user!
    render :text => "dummy"
  end

end
