class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Make sure we always have a permanent cookie
  before_filter :threethings_user
  
  def threethings_user  
    @threethings_user = current_user
    if @threethings_user.nil?
      # Try to load with the saved cookie
      unless cookies[:remember_me].nil?
        @threethings_user = User.where({:session_id => cookies[:remember_me]})[0]
      end
      
      # Try to load with the session id if we haven't found it yet
      if @threethings_user.nil?
        @threethings_user = User.where({:session_id => session[:session_id]})[0]
        cookies.permanent.signed[:remember_me] = session[:session_id]
      end
      
      # Can't find user, create a new one and save a permanent cookie
      if @threethings_user.nil?
        @threethings_user = User.new        
        @threethings_user.session_id = session[:session_id]
        @threethings_user.save!
        cookies.permanent.signed[:remember_me] = session[:session_id]
      end      
    end
    
    @threethings_user
  end
end
