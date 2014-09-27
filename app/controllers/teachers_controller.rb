class TeachersController < ApplicationController
  def index
    @teachers = Teacher.list(params)
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(secure_params)
    @teacher.company_id = session[:company_id] if session[:company_id]
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: "Teacher was successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    lookup_teacher
  end

  def update
    params[:teacher][:course_ids] ||= []
    lookup_teacher
    if @teacher.update_attributes(secure_params)
      redirect_to teacher_path, notice: "Teacher Updated."
    else
      redirect_to teacher_path, alert: "Unable to update teacher."
    end
  end

  private

  def secure_params
    params.require(:teacher).permit( :first_name, :last_name,
                                     { course_ids: [] } )
  end

  def lookup_teacher
    @teacher = Teacher.find(params[:id])
  end
end
