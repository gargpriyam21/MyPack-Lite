class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  # before_action :authorized, only: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /courses or /courses.json
  def index
    @is_allowed = false
    if !check_permissions?(session[:user_role], "create_course")
      @is_allowed = true
    end
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    if !check_permissions?(session[:user_role], "show_course")
      redirect_to root_path
    end
  end

  def showinstructorcourses
    if !check_permissions?(session[:user_role], "show_instructor_student")
      redirect_to root_path
    end
    puts Course.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
    @courses = Course.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  # GET /courses/new
  def new
    if !check_permissions?(session[:user_role], "create_course")
      redirect_to root_path
    end
    @course = Course.new
    # if[!session[:user_role]]
    #   redirect_to root_path
    # end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    # if !check_permissions?(session[:user_role], "create_course")
    #   redirect_to root_path
    # end
    @course = Course.new(course_params)
    puts Instructor.find_by_user_id(session[:user_id]).id
    @course.instructor_id = Instructor.find_by_user_id(session[:user_id]).id
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    if !check_permissions?(session[:user_role], "update_course")
      redirect_to root_path
    end
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if !check_permissions?(session[:user_role], "delete_course")
      redirect_to root_path
    end
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @correctuser = Course.where(user_id: current_user.id)
    redirect_to courses_path if @correctuser.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :instructor_name, :weekdays, :start_time, :end_time, :course_code, :capacity, :students_enrolled, :status, :room)
    end
end
