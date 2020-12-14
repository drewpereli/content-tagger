class AllowNullForContentColumnInItemsTable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :items, :content, true
  end
end
