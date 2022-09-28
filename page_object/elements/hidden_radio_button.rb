class HiddenRadioButton < PageObject::Elements::RadioButton
  def self.accessor_methods(accessor, name)
    accessor.send :define_method, "#{name}_selected?" do
      send("#{name}_element")._selected?
    end

    accessor.send :define_method, "select_#{name}" do
      send("#{name}_element").select
    end
  end

  def select
    label_element.click unless selected?
  end

  def present?
    label_element.present?
  end

  def label_element
    element.browser.label for: element.id
  end
end

PageObject.register_widget :hidden_radio_button, HiddenRadioButton, :radio
