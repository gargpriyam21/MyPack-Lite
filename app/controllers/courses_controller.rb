class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :authorized, only: [:index]


  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  def show_instructor_courses
    @courses = Course.find_by(instructor_name: params[:@current_user.name])
  end

  # GET /courses/new
  def new
    if @course.instructor_name != @current_user.name
      redirect_to root_path
    end
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    if @course.instructor_name != @current_user.name
      redirect_to root_path
    end
    @course = Course.new(course_params)
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
    if @course.instructor_name != @current_user.name
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
    if @course.instructor_name != @current_user.name
      redirect_to root_path
    end
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
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
