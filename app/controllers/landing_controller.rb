class LandingController < ApplicationController
  skip_before_action :require_login

  def index
    # Redirect authenticated users to dashboard
    redirect_to dashboard_path if logged_in?

    @waitlist_signup = WaitlistSignup.new
  end
end
