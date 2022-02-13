class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  # before_action :authorized, only: [:index]
  # before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /courses or /courses.json
  def index
    if !check_permissions?(session[:user_role], "view_course")
      redirect_to root_path
    end
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    if !check_permissions?(session[:user_role], "show_course")
      redirect_to root_path
    end
  end

  def show_instructor_courses
    if !check_permissions?(session[:user_role], "show_instructor_student")
      redirect_to root_path
    end
    @courses = Course.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  def all_students
    puts "Teri maa ka bhosda rails"
    @course = Course.find_by_id(params[:id])
    puts @course.id
    @enrollments = Enrollment.where(course_id: @course.id)
    puts @enrollments.inspect

    students = []

    @enrollments.each do |enrollment|
      students.append(enrollment.student_id)
    end

    puts students

    @students = Student.where(id: students)
  end

  def show_student_enrolled_courses
    if !check_permissions?(session[:user_role], "show_enrolled_course")
      redirect_to root_path
    end
    @enrollments = Enrollment.where(student_id: Student.find_by_user_id(session[:user_id]))
    courses = []
    @enrollments.each do |enrollment|
      courses.append(enrollment.course_id)
    end
    @courses = Course.where(id: courses)
  end

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
    if !check_permissions?(session[:user_role], "edit_course")
      redirect_to root_path
    end
  end

  # POST /courses or /courses.json
  def create
    if !check_permissions?(session[:user_role], "create_course")
      redirect_to root_path
    end
    @course = Course.new(course_params)
    @course.instructor_id = Instructor.find_by_user_id(session[:user_id]).id
    @course.instructor_name = Instructor.find_by_user_id(session[:user_id]).name
    @course.students_enrolled = 0
    @course.students_waitlisted = 0
    @course.status = "OPEN"
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

  def enroll
    if !check_permissions?(session[:user_role], "enroll_course")
      redirect_to root_path
    end
    @course = Course.find_by_id(params[:id])
    @student = Student.find_by_user_id(session[:user_id])
    @instructor = Instructor.find_by_id(@course.instructor_id)

    @enrollment = Enrollment.new
    @enrollment.student_code = @student.student_id
    @enrollment.course_code = @course.course_code
    @enrollment.student_id = @student.id
    @enrollment.course_id = @course.id
    @enrollment.instructor_id = @instructor.id

    already_enrolled = !Enrollment.where(student_id: @student.id, course_id: @course.id)[0].nil?

    respond_to do |format|
      if already_enrolled
        format.html { redirect_to courses_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      else
        if @course.status == 'CLOSED'
          format.html { redirect_to courses_path, alert: @student.name.to_s + " can't be enrolled in " + @course.course_code.to_s + " since, the course is CLOSED" }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        else
          if @enrollment.save
            format.html { redirect_to courses_path, notice: @student.name.to_s + " is successfully enrolled in " + @course.course_code.to_s }
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
    end
  end


  def drop
    if !check_permissions?(session[:user_role], "drop_course")
      redirect_to root_path
    end

    @course = Course.find_by_id(params[:id])
    @student = Student.find_by_user_id(session[:user_id])

    Enrollment.where(student_id: @student.id, course_id: @course.id)[0].destroy

    respond_to do |format|
      format.html { redirect_to student_enrollments_path, notice: @student.name.to_s + " has successfully dropped " + @course.course_code.to_s }
      if @course.status == "CLOSED"
        @course.update(status: "OPEN")
      end
      @course.update(students_enrolled: (@course.students_enrolled - 1))
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
      format.html { redirect_to root_path, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # def correct_user
  #   @correct_user =
  #   redirect_to courses_path if @correctuser.nil?
  # end

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
