class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => :index

  def index
    render :text => "BBQ"
  end

  def miracle
    render :text => "MIRACLE"
  end

  def ponycorns
  end

  def rainbow
    @rainbow = { "wonderful" => true, "colors" => 7 }
    respond_to do |format|
      format.json { render :json => @rainbow }
      format.yaml { render :text => @rainbow.to_yaml }
    end
  end
end
