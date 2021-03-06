class EnrollmentsController < ApplicationController
  before_action :correct_code, only: [:edit, :update, :destroy, :show]
  before_action :set_enrollment, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy, :show]


  # GET /enrollments or /enrollments.json
  def index
    unless check_permissions?(session[:user_role], "view_enrollment")
      redirect_to root_path
    end
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    unless check_permissions?(session[:user_role], "show_enrollment")
      redirect_to root_path
    end
  end

  # GET /enrollments/new
  def new
    unless check_permissions?(session[:user_role], "create_enrollment")
      redirect_to root_path
    end
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    unless check_permissions?(session[:user_role], "edit_enrollment")
      redirect_to root_path
    end
  end

  def correct_user
    @enrollment = Enrollment.find_by_id(params[:id])
    if current_user.user_role == 'instructor'
      if !current_user.nil? && Instructor.find_by_id(@enrollment.instructor_id).user_id != current_user.id
        redirect_to root_path
      end
    end
    if current_user.user_role == 'student'
      if !current_user.nil? && Student.find_by_id(@enrollment.student_id).user_id != current_user.id
        redirect_to root_path
      end
    end
  end

  def correct_code
    if Enrollment.find_by_id(params[:id]).nil?
      redirect_to root_path
    end
  end

  def show_instructor_students_enrolled
    unless check_permissions?(session[:user_role], "show_instructor_students_enrolled")
      redirect_to root_path
    end
    @enrollments = Enrollment.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  # POST /enrollments or /enrollments.json
  def create
    unless check_permissions?(session[:user_role], "create_enrollment")
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

    if @course.status == 'WAITLIST'
      @waitlist = Waitlist.new
      @waitlist.student_code = @enrollment.student_code
      @waitlist.course_code = @course.course_code
      @waitlist.student_id = @student.id
      @waitlist.course_id = @course.id
      @waitlist.instructor_id = @instructor.id
    end

    @enrollment.student_id = @student.id
    @enrollment.course_id = @course.id
    @enrollment.instructor_id = @instructor.id

    already_enrolled = !Enrollment.where(student_id: @student.id, course_id: @course.id)[0].nil?
    already_waitlisted = !Waitlist.where(student_id: @student.id, course_id: @course.id)[0].nil?
    respond_to do |format|
      if current_user.user_role == 'instructor'
        if session[:user_id] == @instructor.user_id
          if already_enrolled
            format.html { redirect_to show_instructor_students_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
            format.json { render json: @enrollment.errors, status: :unprocessable_entity }
          else
            if @course.status == 'WAITLIST'
              if already_waitlisted
                format.html { redirect_to show_instructor_students_path, alert: @student.name.to_s + " is already waitlisted in " + @course.course_code.to_s }
                format.json { render json: @waitlist.errors, status: :unprocessable_entity }
              else
                if @course.students_waitlisted < @course.waitlist_capacity
                  if @waitlist.save
                    format.html { redirect_to show_instructor_students_path, notice: @student.name.to_s + " is successfully waitlisted in " + @course.course_code.to_s }
                    format.json { render :show, status: :created, location: @enrollment }
                    @course.update(students_waitlisted: (@course.students_waitlisted + 1))
                    if @course.waitlist_capacity == @course.students_waitlisted
                      @course.update(status: "CLOSED")
                    end
                  else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                  end
                else
                  format.html { redirect_to show_instructor_students_path, alert: "Waitlist capacity is full" }
                  format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                end
              end
            elsif @course.status == 'CLOSED'
              format.html { redirect_to show_instructor_students_path, alert: @student.name.to_s + " can't be enrolled in " + @course.course_code.to_s + " since, the course is CLOSED" }
              format.json { render json: @enrollment.errors, status: :unprocessable_entity }
            else
              if @enrollment.save
                format.html { redirect_to show_instructor_students_path, notice: @student.name.to_s + " is successfully enrolled in " + @course.course_code.to_s }
                format.json { render :show, status: :created, location: @enrollment }
                @course.update(students_enrolled: (@course.students_enrolled + 1))
                if @course.capacity == @course.students_enrolled
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
        else
          format.html { redirect_to show_instructor_students_path, alert: "You cannot enroll student in courses other than yours" }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        end
      elsif current_user.user_role == "admin"
        if already_enrolled
          format.html { redirect_to enrollments_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        else
          if @course.status == 'WAITLIST'
            if already_waitlisted
              format.html { redirect_to enrollments_path, alert: @student.name.to_s + " is already waitlisted in " + @course.course_code.to_s }
              format.json { render json: @waitlist.errors, status: :unprocessable_entity }
            else
              if @course.students_waitlisted < @course.waitlist_capacity
                if @waitlist.save
                  format.html { redirect_to waitlists_path, notice: @student.name.to_s + " is successfully waitlisted in " + @course.course_code.to_s }
                  format.json { render :show, status: :created, location: @enrollment }
                  @course.update(students_waitlisted: (@course.students_waitlisted + 1))
                  if @course.waitlist_capacity == @course.students_waitlisted
                    @course.update(status: "CLOSED")
                  end
                else
                  format.html { render :new, status: :unprocessable_entity }
                  format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                end
              else
                format.html { redirect_to admins, alert: "Waitlist capacity is full" }
                format.json { render json: @waitlist.errors, status: :unprocessable_entity }
              end
            end
          elsif @course.status == 'CLOSED'
            format.html { redirect_to enrollments_path, alert: @student.name.to_s + " can't be enrolled in " + @course.course_code.to_s + " since, the course is CLOSED" }
            format.json { render json: @enrollment.errors, status: :unprocessable_entity }
          else
            if @enrollment.save
              format.html { redirect_to enrollments_path, notice: @student.name.to_s + " is successfully enrolled in " + @course.course_code.to_s }
              format.json { render :show, status: :created, location: @enrollment }
              @course.update(students_enrolled: (@course.students_enrolled + 1))
              if @course.capacity == @course.students_enrolled
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
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    unless check_permissions?(session[:user_role], "update_enrollment")
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
    unless check_permissions?(session[:user_role], "unenroll_course")
      redirect_to root_path
    end

    @enrollment = Enrollment.find_by_id(params[:id])
    dest_enroll_and_wait
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    unless check_permissions?(session[:user_role], "delete_enrollment")
      redirect_to root_path
    end
    @enrollment = @enrollment
    dest_enroll_and_wait
  end

  private

  def dest_enroll_and_wait
    @course = Course.find_by_id(@enrollment.course_id)
    @student = Student.find_by_id(@enrollment.student_id)

    @waitlists = Waitlist.where(course_id: @course.id).order("created_at ASC")
    @waitlist = @waitlists.first
    @enrollment.destroy

    if !@waitlist.nil?
      @enrollment = Enrollment.new
      @enrollment.student_code = @waitlist.student_code
      @enrollment.course_code = @waitlist.course_code
      @enrollment.course_id = @waitlist.course_id
      @enrollment.student_id = @waitlist.student_id
      @enrollment.instructor_id = @waitlist.instructor_id
      if @enrollment.save
        @course.update(students_waitlisted: (@course.students_waitlisted - 1))
        if @course.capacity == @course.students_enrolled
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
      @waitlist.destroy
      respond_to do |format|
        format.html { redirect_to get_path, notice: @student.name.to_s + " has been successfully unenrolled in " + @course.course_code.to_s }
      end
    else
      respond_to do |format|
        format.html { redirect_to get_path, notice: @student.name.to_s + " has been successfully unenrolled in " + @course.course_code.to_s }
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

  def get_path
    if current_user.user_role == 'admin'
      return all_enrollments_path
    else
      return show_instructor_students_path
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:student_code, :course_code)
  end
end
