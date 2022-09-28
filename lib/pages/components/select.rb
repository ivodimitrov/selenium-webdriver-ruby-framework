module Pages
  module Components
    module Select
      include PageObject

      text_field :search_text_field, css: 'div[class*= search-control] input'
      text_field :old_design_search_text_field, css: '.options .search-box'
      div :options_container_div, css: '.options-container'
      links :options_container_links, css: '.options-container a'
      list_items :options_container_list_items, css: 'div[class*=options] li'

      def search_for(text)
        if search_text_field_element.present?
          scroll_to_element search_text_field_element
          search_text_field_element.send_keys text
        elsif old_design_search_text_field_element.present?
          scroll_to_element old_design_search_text_field_element
          old_design_search_text_field_element.send_keys text
        end
      end

      # 'exact_element' selects exact element when having multiple results after search.
      # 'strip_spaces' will strip leading and trailing white-space from a string.
      def click_element_type_by_value(element_type:, value:)
        element =
          case element_type
          when :exact_li
            browser.li xpath: "//*[@class=\"d-options\"]//li[contains(.,\"#{value}\") and text()=\"#{value}\"]"
          when :exact_a
            browser.a xpath: "//*[@class='options']//a[contains(.,\"#{value}\") and text()=\"#{value}\"]"
          when :a_strip_spaces
            browser.a xpath: "//*[@class='options']//a[contains(.,\"#{value}\") and normalize-space()=\"#{value}\"]"
          when :label
            browser.label xpath: "//label[contains(.,\"#{value}\")]"
          else
            raise ArgumentError, 'Expected: :exact_li, :exact_a, :a_strip_spaces or :label, ' \
                                 "got: '#{element_type}'!"
          end

        scroll_to_element element
        element.wait_until(&:present?).click!
        sleep 1
      end
    end
  end
end
