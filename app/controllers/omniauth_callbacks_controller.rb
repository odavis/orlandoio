class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate_user!

  def all
    # user = User.from_omniauth(request.env["omniauth.auth"])
    
    
    # Create a new user or add an auth to existing user, depending on
    # whether there is already a user signed in.

    auth = request.env['omniauth.auth']
    @auth = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if @auth 
      flash[:notice] = "Signed in successfully"
      sign_in_and_redirect(root_url)
      # sign_in_and_redirect(:user, authorization.user)
    elsif current_user
      current_user.authorizations.create!(provider: auth["provider"], uid: auth["uid"])
      redirect_to authorizations_url
    else
      user = User.new
      user.apply_omniauth(auth)
        if user.save
          flash[:notice] = "Signed in successfully"
          sign_in_and_redirect (root_url)
        else
          session[:auth] = auth.except('extra')
          redirect_to new_user_registration_url
        end
    end

    # # Log the authorizing user in.
    # self.current_user = @auth.user

    # render :text => "Welcome, #{current_user.name}."









    # # if user.persisted?
    # #   sign_in_and_redirect user 
    # #   flash[:notice] = "Signed in!"
    # # else
    # #   session["devise.user_attributes"] = user.attributes
    # #   redirect_to new_user_registration_url
    # #   flash[:alert] =  "Create an account"
    # # end
  end

  alias_method :twitter, :all
  alias_method :github, :all
  alias_method :linkedin, :all 
end



