class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
  skip_before_filter :check_for_email, only: [:edit, :destroy]

    def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case  password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

 def create
  super
  session[:omniauth] = nil unless @user.new_record?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:full_name, :email, :category, :avatar, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:full_name, :email, :password, :password_confirmation ,:category, :avatar) }
  end

  def build_resource(*args)
    super
    if session[:auth]
      binding.pry
      @user.apply_omniauth(session[:auth])
      @user.valid?
    end
  end

end