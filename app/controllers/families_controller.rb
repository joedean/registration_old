class FamiliesController < ApplicationController
  before_filter :set_company_id #make this part of login

  def index
    params[:company_id] ||= session[:company_id]
    @families = Family.list params
  end

  def show
    @family = Family.find(params[:id])
  end

  def new
    @family = Family.new
    @family.addresses.build
    @family.students.build
    @family.guardians.build
  end

  def create
    @family = Family.new(secure_params)
    @family.company_id = session[:company_id] if session[:company_id]
    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: "Family was successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @family = Family.find(params[:id])
    @family.addresses.build if @family.addresses.empty?
  end

  def update
    @family = Family.find(params[:id])
    if @family.update_attributes(secure_params)
      redirect_to families_path, notice: "Family Updated."
    else
      redirect_to families_path, alert: "Unable to update family."
    end
  end

  def destroy
    family = Family.find(params[:id])
    family.destroy
    redirect_to families_path, notice: "Family deleted."
  end

  private

  def secure_params
    params.require(:family).permit(:_destroy,
                                   :name,
                                   :home_phone,
                                   :emergency_contact_name,
                                   :emergency_contact_phone,
                                   :active,
                                   addresses_attributes: [:id, :kind, :street_address,
                                                          :city, :state, :zip_code,
                                                          :_destroy],
                                   students_attributes:  [:id, :first_name, :last_name,
                                                          :mobile_phone, :email,
                                                          :allergies, :medical_information,
                                                          :birth_date, :_destroy],
                                   guardians_attributes: [:id, :first_name, :last_name,
                                                          :mobile_phone, :email,
                                                          :work_phone, :_destroy])
  end

  def set_company_id
    session[:company_id] ||= Company.where(name: "South Bay Dance Center").first.id
  end
end
