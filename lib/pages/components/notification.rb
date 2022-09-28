module Pages
  module Components
    module Notification
      include PageObject

      div :notification_info, css: '.d-notification-info'
      div :notification_warning, css: '.d-notification-warning'
      div :notification_error, css: '.d-notification-error'
    end
  end
end
