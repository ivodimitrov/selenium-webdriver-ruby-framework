module PageObject
  module Elements
    class Table
      # This method is a customization of
      # https://github.com/cheezy/page-object/blob/17275a2d5e2384ab2e8c84082f97861b558ac0c9/lib/page-object/elements/table.rb#L46
      # because the original method does not match by value
      def table_column_elements(column_header)
        idx = find_index_of_header column_header
        row_items.drop(1).collect { |row| row.cell(index: idx).textarea&.value }
      end

      def table_column_checkboxes(column_header)
        idx = find_index_of_header column_header
        row_items.drop(1).collect { |row| row.cell(index: idx).checkbox }
      end
    end
  end
end
