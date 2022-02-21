class WaitlistsController < ApplicationController
  before_action :correct_code, only: [:edit, :update, :destroy, :show]
  before_action :set_waitlist, only: %i[ show edit update destroy ]

  # GET /waitlists or /waitlists.json
  def index
    if !check_permissions?(session[:user_role], "view_waitlist")
      redirect_to root_path
    end
    @waitlists = Waitlist.all
  end

  # GET /waitlists/1 or /waitlists/1.json
  def show
    if !check_permissions?(session[:user_role], "show_waitlist")
      redirect_to root_path
    end
  end

  # GET /waitlists/new
  def new
    if !check_permissions?(session[:user_role], "create_waitlist")
      redirect_to root_path
    end
    @waitlist = Waitlist.new
  end

  # GET /waitlists/1/edit
  def edit
    if !check_permissions?(session[:user_role], "edit_waitlist")
      redirect_to root_path
    end
  end

  def correct_code
    if Waitlist.find_by_id(params[:id]).nil?
      redirect_to root_path
    end
  end

  def show_instructor_students_waitlisted
    if !check_permissions?(session[:user_role], "show_instructor_students_enrolled")
      redirect_to root_path
    end
    @waitlists = Waitlist.where(instructor_id: Instructor.find_by_user_id(session[:user_id]).id)
  end

  # POST /waitlists or /waitlists.json
  def create
    if !check_permissions?(session[:user_role], "create_waitlist")
      redirect_to root_path
    end

    @waitlist = Waitlist.new(waitlist_params)
    @course = Course.find_by_course_code(@waitlist.course_code)
    @student = Student.find_by_student_id(@waitlist.student_code)

    if @student.nil?
      flash[:alert] = "Student doesn't exist"
      redirect_to new_waitlist_path
      return
    elsif @course.nil?
      flash[:alert] = "Course doesn't exist"
      redirect_to new_waitlist_path
      return
    end

    @instructor = Instructor.find_by_id(@course.instructor_id)
    @waitlist.student_id = @student.id
    @waitlist.course_id = @course.id
    @waitlist.instructor_id = @instructor.id

    already_enrolled = !Enrollment.where(student_id: @student.id, course_id: @course.id)[0].nil?
    already_waitlisted = !Waitlist.where(student_id: @student.id, course_id: @course.id)[0].nil?

    if current_user.user_role == 'instructor'
      respond_to do |format|
        if current_user.user_role == 'instructor' and session[:user_id] == @instructor.user_id
          if already_enrolled
            format.html { redirect_to show_instructor_students_waitlisted_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
            format.json { render json: @enrollment.errors, status: :unprocessable_entity }
          else
            if @course.status != 'CLOSED'
              if already_waitlisted
                format.html { redirect_to show_instructor_students_waitlisted_path, alert: @student.name.to_s + " is already waitlisted in " + @course.course_code.to_s }
                format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                #render show_instructor_students_waitlisted_path
              else
                if @course.students_waitlisted < @course.waitlist_capacity
                  if @waitlist.save
                    @course.update(students_waitlisted: (@course.students_waitlisted + 1))
                    format.html { redirect_to show_instructor_students_waitlisted_path, alert: @student.name.to_s + " is successfully waitlisted in " + @course.course_code.to_s }
                    format.json { render :show, status: :created, location: @waitlist }
                    if @course.students_enrolled == @course.capacity
                      if @course.waitlist_capacity == @course.students_waitlisted
                        @course.update(status: "CLOSED")
                      end
                    end
                  else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                  end
                else
                  format.html { redirect_to show_instructor_students_waitlisted_path, alert: "Waitlist capacity is full" }
                  format.json { render json: @waitlist.errors, status: :unprocessable_entity }
                end
              end
            else
              format.html { redirect_to show_instructor_students_waitlisted_path, alert: @student.name.to_s + " can't be waitlisted in " + @course.course_code.to_s + " since, the course is CLOSED" }
              format.json { render json: @waitlist.errors, status: :unprocessable_entity }
            end
          end
        else
          format.html { redirect_to show_instructor_students_waitlisted_path, alert: "You cannot waitlist student in courses other than yours" }
          format.json { render json: @waitlist.errors, status: :unprocessable_entity }
        end
      end
    elsif current_user.user_role == "admin"
      respond_to do |format|
        if already_enrolled
          format.html { redirect_to admins_path, alert: @student.name.to_s + " is already enrolled in " + @course.course_code.to_s }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        else
          if @course.status == 'WAITLIST'
            if already_waitlisted
              format.html { redirect_to admins_path, alert: @student.name.to_s + " is already waitlisted in " + @course.course_code.to_s }
              format.json { render json: @waitlist.errors, status: :unprocessable_entity }
            else
              if @course.students_waitlisted < @course.waitlist_capacity
                if @waitlist.save
                  format.html { redirect_to admins_path, notice: @student.name.to_s + " is successfully waitlisted in " + @course.course_code.to_s }
                  format.json { render :show, status: :created, location: @waitlist }
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
            format.html { redirect_to admins_path, alert: @student.name.to_s + " can't be waitlisted in " + @course.course_code.to_s + " since, the course is CLOSED" }
            format.json { render json: @waitlist.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /waitlists/1 or /waitlists/1.json
  def update
    respond_to do |format|
      if @waitlist.update(waitlist_params)
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully updated." }
        format.json { render :show, status: :ok, location: @waitlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_list
    if !check_permissions?(session[:user_role], "remove_waitlist")
      redirect_to root_path
    end

    @waitlist = Waitlist.find_by_id(params[:id])

    @waitlist.destroy
    @course = Course.find_by_id(@waitlist.course_id)
    @student = Student.find_by_id(@waitlist.student_id)

    respond_to do |format|
      format.html { redirect_to show_instructor_students_waitlisted_path, notice: @student.name.to_s + " has been successfully removed from waitlist in " + @course.course_code.to_s }
      @course.update(students_waitlisted: (@course.students_waitlisted - 1))
    end
  end

  # DELETE /waitlists/1 or /waitlists/1.json
  def destroy
    if !check_permissions?(session[:user_role], "delete_waitlist")
      redirect_to root_path
    end

    @courses = Course.find_by_id(id: @enrollment.course_id)
    @courses.each do |course|
      course.update(students_waitlisted: (@course.students_waitlisted - 1))
      if course.status = "CLOSED"
        course.update(status: "WAITLIST")
      end
    end
    @waitlist.destroy

    respond_to do |format|
      format.html { redirect_to waitlists_url, notice: "Waitlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_waitlist
    @waitlist = Waitlist.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def waitlist_params
    params.require(:waitlist).permit(:student_code, :course_code)
  end
end
