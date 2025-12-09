class UsersController < ApplicationController
  # Ensure user is logged in before accessing any action except sign-up
  before_action :require_login, except: [:new, :create]
  # Load the user object before show, edit, update, and destroy actions
  before_action :set_user, only: %i[show edit update destroy]

  # user login requirement
  def require_login
    unless current_user
      redirect_to login_path, alert: "Please log in to access your profile."
    end
  end


  # GET /users or /users.json
  def index # Manage user page only allows for admin users only
    unless current_user&.is_admin?
      redirect_to user_path(current_user), alert: "Access denied. Admins only."
      return
    end

    @users = User.all
  end


  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Redirect to login after successful sign-up
        format.html { redirect_to login_path, notice: "Sign up successful. Please log in." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        if current_user.is_admin?
          # Admin goes to manage users
          format.html { redirect_to users_path, notice: "User was successfully updated." } 
        else
          # Standard user goes to their profile
          format.html { redirect_to userhome_path(@user), notice: "Your profile was successfully updated." } 
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    allowed = [:fname, :lname, :email, :password, :password_confirmation]
    allowed += [:status, :is_admin] if current_user&.is_admin
    params.require(:user).permit(allowed)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    # Restrict access to admin-only actions
    def require_admin
      unless is_administrator?
        redirect_to root_path, alert: "Access denied."
      end
    end


end
