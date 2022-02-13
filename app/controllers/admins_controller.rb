class AdminsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_admin, only: %i[ show edit update destroy ]
  #Include Foreign Keys
  # GET /admins or /admins.json
  def index
    if !check_permissions?(session[:user_role], "view_admin")
      redirect_to root_path
    end
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
    if !check_permissions?(session[:user_role], "show_admin")
      redirect_to root_path
    end
  end

  # GET /admins/new
  def new
    if !check_permissions?(session[:user_role], "create_admin")
      redirect_to root_path
    end
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
    if !check_permissions?(session[:user_role], "edit_admin")
      redirect_to root_path
    end
  end

  # POST /admins or /admins.json
  def create
    if !check_permissions?(session[:user_role], "create_admin")
      redirect_to root_path
    end
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to admin_url(@admin), notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    if !check_permissions?(session[:user_role], "update_admin")
      redirect_to root_path
    end
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admin_url(@admin), notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    if !check_permissions?(session[:user_role], "delete_admin")
      redirect_to root_path
    end
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:admin_id, :password, :name, :email, :phone_number)
    end
end
