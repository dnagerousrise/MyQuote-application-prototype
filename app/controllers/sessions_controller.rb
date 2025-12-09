class SessionsController < ApplicationController

    def new
    end
    # Checking login is valid (banned, suspended, or invalid credentials)
    def create
        user = User.find_by(email: params[:email]) # Finds the user
        if user && user.authenticate(params[:password]) # Authenticate by the password
            # Checks for profile status
            if user.suspended? 
            flash[:error] = "Your account is suspended."
            redirect_to login_path
            elsif user.banned?
            flash[:error] = "Your account has been banned."
            redirect_to login_path
            else
            # No flags allows to login to the system
            session[:user_id] = user.id
            session[:fname] = user.fname
            session[:is_admin] = user.is_admin

            if user.is_admin?
                # Direct to aindex.html.erb
                redirect_to adminhome_path 
            else
                # Direct to unidex.html.erb
                redirect_to userhome_path
            end
            end
        else
            # Invalid user credentials
            flash[:error] = "Invalid email or password."
            redirect_to login_path
        end
    end


    # User signing out
    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "Logged out successfully!"
    end

end
