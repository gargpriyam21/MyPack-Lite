class StudentsController < ApplicationController
  # skip_before_action :authorized, only: [:new, :create]
  # before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    if (!current_user.nil? && !check_permissions?(session[:user_role], "view_student"))
      redirect_to root_path
    end
    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
    if (!current_user.nil? && !check_permissions?(session[:user_role], "show_student"))
      redirect_to root_path
    end
  end

  # GET /students/new
  def new
    if (!current_user.nil? && !check_permissions?(session[:user_role], "create_student"))
      redirect_to root_path
    end
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    if (!current_user.nil? && !check_permissions?(session[:user_role], "edit_student"))
      redirect_to root_path
    end
  end

  # POST /students or /students.json
  def create
    if (!current_user.nil? && !check_permissions?(session[:user_role], "create_student"))
      redirect_to root_path
    end
    email = params[:student][:email]
    user = { :email => email, :user_role => 'student' }
    @student = nil
    @user = User.new(user)

    respond_to do |format|
      if @user.save
        @student = Student.new(student_params)
        @student.user_id = @user.id
        if @student.save
          if (not current_user.nil? and current_user.user_role == "admin")
            format.html { redirect_to @student, notice: "Student was successfully created by Admin." }
            format.json { render :show, status: :created, location: @student }
          else
            format.html { redirect_to login_path, notice: "Student was successfully created." }
            format.json { render :show, status: :created, location: @student }
          end
        else
          User.where(id: @user.id)[0].destroy
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    if (!current_user.nil? && !check_permissions?(session[:user_role], "update_student"))
      redirect_to root_path
    end
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    if (!current_user.nil? && !check_permissions?(session[:user_role], "delete_student"))
      redirect_to root_path
    end

    @enrollments = Enrollment.where(student_id: @student.id)
    courses = []
    @enrollments.each do |enrollment|
      courses.append(enrollment.course_id)
    end

    @courses = Course.where(id: courses)
    @courses.each do |course|
      if course.status = "CLOSED"
        course.update(status: "OPEN")
      end
      course.update(students_enrolled: (course.students_enrolled - 1))
    end

    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:name, :student_id, :email, :password, :date_of_birth, :phone_number, :major)
  end
end
