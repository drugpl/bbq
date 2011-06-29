class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => :index

  def index
    render :text => "BBQ"
  end

  def miracle
    render :text => "MIRACLE"
  end
end
