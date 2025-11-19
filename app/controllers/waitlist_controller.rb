class WaitlistController < ApplicationController
  skip_before_action :require_login

  def create
    @waitlist_signup = WaitlistSignup.new(waitlist_params)

    if @waitlist_signup.save
      render json: {
        success: true,
        message: "Thanks for joining! We'll be in touch soon."
      }
    else
      render json: {
        success: false,
        errors: @waitlist_signup.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def waitlist_params
    params.require(:waitlist_signup).permit(:email)
  end
end
