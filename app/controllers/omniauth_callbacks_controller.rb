class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    # user = User.from_omniauth(env["omniauth.auth"], current_user)
    if user.persisted?
      sign_in_and_redirect user 
      flash[:notice] = "Signed in!"
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url, alert: "Redirect to save"
    end
  end

  alias_method :twitter, :all
  alias_method :github, :all
  alias_method :linkedin, :all 
end
