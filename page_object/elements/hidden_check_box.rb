class HiddenCheckBox < PageObject::Elements::CheckBox
  def self.accessor_methods(accessor, name)
    accessor.send :define_method, "#{name}_checked?" do
      send("#{name}_element").checked?
    end

    accessor.send :define_method, "check_#{name}" do
      send("#{name}_element").check
    end

    accessor.send :define_method, "uncheck_#{name}" do
      send("#{name}_element").uncheck
    end
  end

  def check
    label_element.click unless checked?
  end

  def uncheck
    label_element.click if checked?
  end

  def present?
    label_element.present?
  end

  def label_element
    element.browser.label for: element.id
  end
end

PageObject.register_widget :hidden_checkbox, HiddenCheckBox, :checkbox
