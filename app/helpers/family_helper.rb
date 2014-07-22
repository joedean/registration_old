module FamilyHelper
  def age(student)
    return "?" unless student.birth_date
    student.age
  end
end
