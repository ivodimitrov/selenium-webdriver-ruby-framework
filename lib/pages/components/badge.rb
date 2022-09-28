module Pages
  module Components
    module Badge
      include PageObject

      span :badge, css: '.d-badge'
      spans :badges, css: '.d-badge'
    end
  end
end
