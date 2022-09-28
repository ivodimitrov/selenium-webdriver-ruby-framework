module Pages
  module Components
    module Error
      include PageObject

      div :warning_message, css: '.d-form-warning-message'
      divs :warning_messages, css: '.d-form-warning-message'
      div :error_message_div, css: 'div[class*="form-error-message"]'
      span :error_message_span, css: 'span[class*="form-error-message"]'
      span :old_design_error_message, css: 'span.error'
      spans :old_design_error_messages, css: 'span.error'
    end
  end
end
