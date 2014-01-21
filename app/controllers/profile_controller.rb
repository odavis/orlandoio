class ProfileController < ApplicationController
 
 def index
  @users = User.order(:created_at).page params[:page]
  #@profile = @users.profile.where(public: true)
  #binding.pry
 end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @social_links = SocialLink.where(profile_id: @user)
  end

  def edit
    @user ||= current_user
    @profile = @user.profile
    # @social = SocialLink.friendly.find(params[:id])
    @social_links = SocialLink.where(profile_id: @profile.id) # array of all social links 
  end

  def update

    @user ||= current_user
    @profile = @user.profile
  
    if @profile.update_attributes(profile_params)
      flash[:notice] = "Profile Updated"
      redirect_to profile_path(current_user)
    else
      flash[:error] = "Error updating profile"
      render :edit
    end
  end


  private
  def profile_params
    params.require(:profile).permit(:bio, :avatar, :category, social_links_attributes: [:id, :account, :link, :_destroy])
  end
end
