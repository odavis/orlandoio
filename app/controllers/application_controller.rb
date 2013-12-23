class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_filter :check_for_email

  private 

  def check_for_email
    if current_user
      if current_user.email == "" 
        redirect_to edit_user_registration_path  
        flash[:notice] = "Add an email address"
      end
    end
  end
end


