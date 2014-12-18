class SessionsController < ApplicationController
  #before_action :check_session, :only [:create]

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        if user.activated?
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or root_url
        else
          message  = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
    end

    #Normal user login without account activation process
      #log_in user
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      #remember user
      #redirect_back_or user
      # Log the user in and redirect to the user's show page.
    else
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end



  def destroy
    log_out
    redirect_to root_url
  end

  def check_session
  end


end
