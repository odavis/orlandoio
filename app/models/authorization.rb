class Authorization < ActiveRecord::Base
  belongs_to :user 

  def fetch_details
    binding.pry
    self.send("fetch_details_from_#{self.provider.downcase}")
  end

  def fetch_details_from_facebook
  end

  def fetch_details_from_twitter
  end

  def fetch_details_from_github
  end

  def fetch_details_from_linkedin
  end

  
end
