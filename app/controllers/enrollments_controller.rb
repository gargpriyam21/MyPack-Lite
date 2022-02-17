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

  def show_instructor_students_enrolled
    @enrollments = Enrollment.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  # POST /enrollments or /enrollments.json
  def create
    if !check_permissions?(session[:user_role], "create_enrollment")
      redirect_to root_path
    end

    @enrollment = Enrollment.new(enrollment_params)
    @course = Course.find_by_course_code(@enrollment.course_code)
    @student = Student.find_by_student_id(@enrollment.student_code)


    if @student.nil?
      flash[:alert] = "Student doesn't exist"
      redirect_to new_enrollment_path
      return
    elsif @course.nil?
      flash[:alert] = "Course doesn't exist"
      redirect_to new_enrollment_path
      return
    end

    @instructor = Instructor.find_by_id(@course.instructor_id)

    @enrollment.student_id = @student.id
    @enrollment.course_id = @course.id
    @enrollment.instructor_id = @instructor.id

    already_enrolled = !Enrollment.where(student_id: @student.id, course_id: @course.id)[0].nil?

    respond_to do |format|
      if current_user.user_role == 'instructor' and session[:user_id] == @instructor.user_id
        if already_enrolled
          format.html { redirect_to show_instructor_students_enrolled_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        else
          if @course.status == 'CLOSED'
            format.html { redirect_to show_instructor_students_enrolled_path, alert: @student.name.to_s + " can't be enrolled in " + @course.course_code.to_s + " since, the course is CLOSED" }
            format.json { render json: @enrollment.errors, status: :unprocessable_entity }
          else
            if @enrollment.save
              format.html { redirect_to show_instructor_students_enrolled_path, notice: @student.name.to_s + " is successfully enrolled in " + @course.course_code.to_s }
              format.json { render :show, status: :created, location: @enrollment }
              @course.update(students_enrolled: (@course.students_enrolled + 1))
              if @course.capacity == @course.students_enrolled
                @course.update(status: "CLOSED")
              end
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @enrollment.errors, status: :unprocessable_entity }
            end
          end
        end
      else
        format.html { redirect_to show_instructor_students_enrolled_path, alert: "You cannot enroll student in courses other than yours" }
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

  def unenroll
    # if !check_permissions?(session[:user_role], "unenroll_course")
    #   redirect_to root_path
    # end

    @enrollment = Enrollment.find_by_id(params[:id])

    @enrollment.destroy
    @course = Course.find_by_id(@enrollment.course_id)
    @student = Student.find_by_id(@enrollment.student_id)
    respond_to do |format|
      format.html { redirect_to show_instructor_students_enrolled_path, notice: @student.name.to_s + " has been successfully unenrolled in " + @course.course_code.to_s }
      if @course.status == "CLOSED"
        @course.update(status: "OPEN")
      end
      @course.update(students_enrolled: (@course.students_enrolled - 1))
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    # if !check_permissions?(session[:user_role], "delete_enrollment")
    #   redirect_to root_path
    # end
    # @course = Course.find_by_id(@enrollment.course_id)
    # if @course.status = "CLOSED"
    #   @course.update(status: "OPEN")
    # end
    # @course.update(students_enrolled: (@course.students_enrolled - 1))

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

    # @enrollment.destroy

    # respond_to do |format|
    #   format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
    #   format.json { head :no_content }
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:student_code, :course_code)
  end
end
