module BrandsHelper
  def fields_for_experience(experience, &block)
    prefix = experience.new_record? ? 'new' : 'existing'
    fields_for("brand[#{prefix}_experience_attributes][]", experience, &block)
  end
end
