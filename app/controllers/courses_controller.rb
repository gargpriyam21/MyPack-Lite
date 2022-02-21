class CoursesController < ApplicationController
  before_action :correct_code, only: [:edit, :update, :destroy, :show]
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy, :show]

  # GET /courses or /courses.json
  def index
    unless check_permissions?(session[:user_role], "view_course")
      redirect_to root_path
    end
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    unless check_permissions?(session[:user_role], "show_course")
      redirect_to root_path
    end
  end

  def new
    unless check_permissions?(session[:user_role], "create_course")
      redirect_to root_path
    end
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    unless check_permissions?(session[:user_role], "edit_course")
      redirect_to root_path
    end
  end

  def correct_user
    @course = Course.find_by_id(params[:id])
    if current_user.user_role != 'admin'
      if !current_user.nil? && Instructor.find_by_id(@course.instructor_id).user_id != current_user.id
        redirect_to root_path
      end
    end
  end

  def correct_code
    if Course.find_by_id(params[:id]).nil?
      redirect_to root_path
    end
  end

  # POST /courses or /courses.json
  def create
    unless check_permissions?(session[:user_role], "create_course")
      redirect_to root_path
    end

    fill_course_details

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
    unless check_permissions?(session[:user_role], "enroll_course")
      redirect_to root_path
    end

    fill_enroll_details

    already_enrolled = !Enrollment.where(student_id: @student.id, course_id: @course.id)[0].nil?
    already_waitlisted = !Waitlist.where(student_id: @student.id, course_id: @course.id)[0].nil?

    respond_to do |format|
      if already_enrolled
        format.html { redirect_to courses_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      else
        if @course.status == 'WAITLIST'
          if already_waitlisted
            format.html { redirect_to show_instructor_students_enrolled_path, alert: @student.name.to_s + " is already waitlisted in " + @course.course_code.to_s }
            format.json { render json: @waitlist.errors, status: :unprocessable_entity }
          else
            if @course.students_waitlisted < @course.waitlist_capacity
              if @waitlist.save
                format.html { redirect_to courses_path, notice: @student.name.to_s + " is successfully waitlisted in " + @course.course_code.to_s }
                format.json { render :show, status: :created, location: @waitlist }
                @course.update(students_waitlisted: (@course.students_waitlisted + 1))
                if @course.students_waitlisted == @course.waitlist_capacity
                  @course.update(status: "CLOSED")
                end
              else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @waitlist.errors, status: :unprocessable_entity }
              end
            else
              format.html { redirect_to courses_path, alert: "Waitlist capacity is full" }
              format.json { render json: @waitlist.errors, status: :unprocessable_entity }
            end
          end
        elsif @course.status == 'CLOSED'
          format.html { redirect_to courses_path, alert: @student.name.to_s + " can't be enrolled in " + @course.course_code.to_s + " since, the course is CLOSED" }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        else
          if @enrollment.save
            format.html { redirect_to courses_path, notice: @student.name.to_s + " is successfully enrolled in " + @course.course_code.to_s }
            format.json { render :show, status: :created, location: @enrollment }
            @course.update(students_enrolled: (@course.students_enrolled + 1))
            if @course.students_enrolled == @course.capacity
              if @course.students_waitlisted < @course.waitlist_capacity
                @course.update(status: "WAITLIST")
              else
                @course.update(status: "CLOSED")
              end
            end
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @enrollment.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  def show_instructor_courses
    unless check_permissions?(session[:user_role], "show_instructor_student")
      redirect_to root_path
    end
    @courses = Course.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  def all_students
    unless check_permissions?(session[:user_role], "show_all_student")
      redirect_to root_path
    end
    @course = Course.find_by_id(params[:id])
    @enrollments = Enrollment.where(course_id: @course.id)

    students = []

    @enrollments.each do |enrollment|
      students.append(enrollment.student_id)
    end

    @students = Student.where(id: students)
  end

  def show_student_enrolled_courses
    unless check_permissions?(session[:user_role], "show_enrolled_course")
      redirect_to root_path
    end
    @enrollments = Enrollment.where(student_id: Student.find_by_user_id(session[:user_id]))
    courses = []
    @enrollments.each do |enrollment|
      courses.append(enrollment.course_id)
    end
    @courses = Course.where(id: courses)
  end

  def show_student_waitlisted_courses
    unless check_permissions?(session[:user_role], "show_waitlist_course")
      redirect_to root_path
    end
    @waitlists = Waitlist.where(student_id: Student.find_by_user_id(session[:user_id]))
    courses = []
    @waitlists.each do |waitlist|
      courses.append(waitlist.course_id)
    end
    @courses = Course.where(id: courses)
  end

  def drop
    unless check_permissions?(session[:user_role], "drop_course")
      redirect_to root_path
    end

    @course = Course.find_by_id(params[:id])
    @student = Student.find_by_user_id(session[:user_id])

    @enrollment = Enrollment.where(student_id: @student.id, course_id: @course.id)
    @enrollment[0].destroy

    @waitlists = Waitlist.where(course_id: @course.id).order("created_at ASC")
    @waitlist = @waitlists.first

    if !@waitlist.nil?
      shift_wait_to_enroll
    else
      respond_to do |format|
        format.html { redirect_to student_enrollments_path, notice: @student.name.to_s + " has successfully dropped " + @course.course_code.to_s }
        if @course.status == "WAITLIST"
          @course.update(status: "OPEN")
        elsif @course.status == "CLOSED"
          if @course.waitlist_capacity == 0
            @course.update(status: "OPEN")
          else
            @course.update(status: "WAITLIST")
          end
        end
        @course.update(students_enrolled: (@course.students_enrolled - 1))
      end
    end
  end

  def drop_waitlist
    unless check_permissions?(session[:user_role], "remove_waitlist")
      redirect_to root_path
    end

    @course = Course.find_by_id(params[:id])
    @student = Student.find_by_user_id(session[:user_id])

    @waitlist = Waitlist.where(student_id: @student.id, course_id: @course.id)
    @waitlist[0].destroy
    @course.update(students_waitlisted: (@course.students_waitlisted - 1))

    if @course.status == "WAITLIST"
      @course.update(status: "OPEN")
    elsif @course.status == "CLOSED"
      if @course.waitlist_capacity == 0
        @course.update(status: "OPEN")
      else
        @course.update(status: "WAITLIST")
      end

    end
    respond_to do |format|
      format.html { redirect_to student_waitlists_path, notice: @student.name.to_s + " has been successfully removed from waitlist in " + @course.course_code.to_s }
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    unless check_permissions?(session[:user_role], "update_course")
      redirect_to root_path
    end

    cant_update_course = course_params[:capacity].to_i < @course.students_enrolled

    respond_to do |format|
      if cant_update_course
        format.html { redirect_to edit_course_path(@course), alert: "There are more students enrolled than capacity" }
        format.json { render :show, status: :ok, location: @course }
      else
        if @course.update(course_params)
          format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }

          if @course.capacity > @course.students_enrolled
            @course.update(status: 'OPEN')
          elsif @course.capacity == @course.students_enrolled
            @course.update(status: 'CLOSED')
          end

          format.json { render :show, status: :ok, location: @course }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    unless check_permissions?(session[:user_role], "delete_course")
      redirect_to root_path
    end
    @course.destroy

    if @current_user.user_role == 'instructor'
      respond_to do |format|
        format.html { redirect_to instructor_courses_path, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    elsif @current_user.user_role == 'admin'
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private

  def shift_wait_to_enroll
    @enrollment = Enrollment.new
    @enrollment.student_code = @waitlist.student_code
    @enrollment.course_code = @waitlist.course_code
    @enrollment.course_id = @waitlist.course_id
    @enrollment.student_id = @waitlist.student_id
    @enrollment.instructor_id = @waitlist.instructor_id
    if @enrollment.save
      if @course.capacity == @course.students_enrolled
        if @course.students_waitlisted < @course.waitlist_capacity
          @course.update(status: "WAITLIST")
        else
          @course.update(status: "CLOSED")
        end
        @course.update(students_waitlisted: (@course.students_waitlisted - 1))
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @enrollment.errors, status: :unprocessable_entity }
    end
    @waitlist.destroy
    respond_to do |format|
      format.html { redirect_to student_enrollments_path, notice: @student.name.to_s + " has successfully dropped in " + @course.course_code.to_s }
    end
  end

  def fill_enroll_details
    @course = Course.find_by_id(params[:id])
    @student = Student.find_by_user_id(session[:user_id])
    @instructor = Instructor.find_by_id(@course.instructor_id)

    if @course.status == 'WAITLIST'
      @waitlist = Waitlist.new
      @waitlist.student_code = @student.student_id
      @waitlist.course_code = @course.course_code
      @waitlist.student_id = @student.id
      @waitlist.course_id = @course.id
      @waitlist.instructor_id = @instructor.id
    else
      @enrollment = Enrollment.new
      @enrollment.student_code = @student.student_id
      @enrollment.course_code = @course.course_code
      @enrollment.student_id = @student.id
      @enrollment.course_id = @course.id
      @enrollment.instructor_id = @instructor.id
    end
  end

  def fill_course_details
    @course = Course.new(course_params)

    if session[:user_role] == 'admin'
      @course.instructor_id = Instructor.find_by_instructor_id(course_params[:instructor_name]).id
      @course.instructor_name = Instructor.find_by_instructor_id(course_params[:instructor_name]).name
    else
      @course.instructor_id = Instructor.find_by_user_id(session[:user_id]).id
      @course.instructor_name = Instructor.find_by_user_id(session[:user_id]).name
    end

    @course.students_enrolled = 0
    @course.students_waitlisted = 0
    @course.status = "OPEN"

    if @course.weekday2 == ' '
      @course.weekday2 = nil
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:name, :description, :instructor_name, :weekday1, :weekday2, :start_time, :end_time, :course_code, :capacity, :students_enrolled, :waitlist_capacity, :students_enrolled, :status, :room)
  end
end
