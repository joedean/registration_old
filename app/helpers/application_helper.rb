module ApplicationHelper
  def link_to_add_fields(name, form, association)
    new_object = form.object.class.reflect_on_association(association).klass.new
    fields = form.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :form => builder)
    end
    link_id = name.tr(" ", "_").downcase + "_link"
    link_to(name,
            "javascript: $.fn.add_fields(\"##{link_id}\", \"#{association}\", \"#{escape_javascript(fields)}\")",
            id: link_id)
  end

  def link_to_remove_fields(name, form, &block)
    form.hidden_field(:_destroy) + link_to(name, class: "remove-link")
  end
end
