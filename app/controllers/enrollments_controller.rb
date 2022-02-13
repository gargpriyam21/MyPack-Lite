class EnrollmentsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    if !check_permissions?(session[:user_role], "view_enrollment")
      redirect_to root_path
    end
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    if !check_permissions?(session[:user_role], "show_enrollment")
      redirect_to root_path
    end
  end

  # GET /enrollments/new
  def new
    if !check_permissions?(session[:user_role], "create_enrollment")
      redirect_to root_path
    end
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    if !check_permissions?(session[:user_role], "edit_enrollment")
      redirect_to root_path
    end
  end

  # POST /enrollments or /enrollments.json
  def create
    if !check_permissions?(session[:user_role], "create_enrollment")
      redirect_to root_path
    end

    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    if !check_permissions?(session[:user_role], "update_enrollment")
      redirect_to root_path
    end

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    # if !check_permissions?(session[:user_role], "delete_enrollment")
    #   redirect_to root_path
    # end
    @course = Course.find_by_id(@enrollment.course_id)
    if @course.status = "CLOSED"
      @course.update(status: "OPEN")
    end
    @course.update(students_enrolled: (@course.students_enrolled - 1))

    puts "-------------------------------------"
    puts "Student Destroyed:" + @student.name
    # @enrollments = Enrollment.where(student_id: @student.id)
    # courses = []
    # @enrollments.each do |enrollment|
    #   courses.append(enrollment.course_id)
    # end
    #
    # @courses = Course.where(id: courses)
    # @courses.each do |course|
    #   if course.status = "CLOSED"
    #     course.update(status: "OPEN")
    #   end
    #   course.update(students_enrolled: (@course.students_enrolled - 1))
    # end

    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:student_id, :course_id)
  end
end
