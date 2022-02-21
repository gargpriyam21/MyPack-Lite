class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    unless check_permissions?(session[:user_role], "view_admin")
      redirect_to root_path
    end
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
    unless check_permissions?(session[:user_role], "show_admin")
      redirect_to root_path
    end
  end

  # GET /admins/new
  def new
    unless check_permissions?(session[:user_role], "create_admin")
      redirect_to root_path
    end
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
    unless check_permissions?(session[:user_role], "edit_admin")
      redirect_to root_path
    end
  end

  def all_enrollments
    @enrollments = Enrollment.all.order("student_code ASC")
    @waitlists = Waitlist.all.order("student_code ASC")
  end

  # POST /admins or /admins.json
  def create
    unless check_permissions?(session[:user_role], "create_admin")
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
    unless check_permissions?(session[:user_role], "update_admin")
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
    unless check_permissions?(session[:user_role], "delete_admin")
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
