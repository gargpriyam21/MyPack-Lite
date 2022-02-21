class InstructorsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_instructor, only: %i[ show edit update destroy ]
  before_action :correct_user,  only: [:edit, :update, :destroy, :show]

  # GET /instructors or /instructors.json
  def index
    if !check_permissions?(session[:user_role], "view_instructor")
      redirect_to root_path
    end
    @instructors = Instructor.all
  end

  # GET /instructors/1 or /instructors/1.json
  def show
    if !check_permissions?(session[:user_role], "show_instructor")
      redirect_to root_path
    end
  end

  # GET /instructors/new
  def new
    if (!current_user.nil? && !check_permissions?(session[:user_role], "create_instructor"))
      redirect_to root_path
    end
    @instructor = Instructor.new
  end

  # GET /instructors/1/edit
  def edit
    if !check_permissions?(session[:user_role], "edit_instructor")
      redirect_to root_path
    end
  end

  def correct_user
    @instructor = Instructor.find_by_id ( params[:id] )
    if !current_user.nil? && @instructor.user_id != current_user.id
      redirect_to root_path
    end
  end

  # POST /instructors or /instructors.json
  def create
    if (!current_user.nil? && !check_permissions?(session[:user_role], "create_instructor"))
      redirect_to root_path
    end
    email = params[:instructor][:email]
    user = { :email => email, :user_role => 'instructor' }
    @instructor = nil
    @user = User.new(user)

    respond_to do |format|
      if @user.save
        @instructor = Instructor.new(instructor_params)
        @instructor.user_id = @user.id
        if @instructor.save
          if (not current_user.nil? and current_user.user_role == "admin")
            format.html { redirect_to @instructor, notice: "Instructor was successfully created by Admin." }
            format.json { render :show, status: :created, location: @instructor }
          else
            format.html { redirect_to login_path, notice: "Instructor was successfully created." }
            format.json { render :show, status: :created, location: @instructor }
          end
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @instructor.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /instructors/1 or /instructors/1.json
  def update
    if !check_permissions?(session[:user_role], "update_instructor")
      redirect_to root_path
    end
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully updated." }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1 or /instructors/1.json
  def destroy
    if !check_permissions?(session[:user_role], "delete_instructor")
      redirect_to root_path
    end
    @instructor.destroy

    respond_to do |format|
      format.html { redirect_to instructors_url, notice: "Instructor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_instructor
    @instructor = Instructor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def instructor_params
    params.require(:instructor).permit(:instructor_id, :name, :email, :password, :department)
  end
end
