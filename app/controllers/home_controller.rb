class HomeController < ApplicationController
  def index
    render :layout => "welcome"
  end

end
