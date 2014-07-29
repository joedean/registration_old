class CoursesController < ApplicationController
  def index
    @courses = Course.list(params)
  end

  def show
    @course = Course.find(params[:id])
    puts "done with show"
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(secure_params)
    @course.company_id = session[:company_id]
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Class was successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(secure_params)
      redirect_to courses_path, notice: "Course Updated."
    else
      redirect_to courses_path, alert: "Unable to update course."
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    redirect_to courses_path, notice: "Corse deleted."
  end

  def secure_params
    params.required(:course).permit(:category, :name,
                                    :level, :start_age,
                                    :end_age, :wday,
                                    :start_at, :end_at,
                                    :studio, :max_size);
  end
end
