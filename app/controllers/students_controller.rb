class StudentsController < ApplicationController
  def index
    @course = Course.find(params[:course_id].to_i) if params[:course_id]
    @students = Student.list(params)
  end

  def show
    lookup_student
  end

  def edit
    lookup_student
  end

  def update
    params[:student][:course_ids] ||= []
    lookup_student
    if @student.update_attributes(secure_params)
      redirect_to student_path, notice: "Student Updated."
    else
      redirect_to student_path, alert: "Unable to update student."
    end
  end

  private

  def secure_params
    params.require(:student).permit( :first_name, :last_name,
                                     { course_ids: [] } )
  end

  def lookup_student
    @student = Student.find(params[:id])
  end
end
