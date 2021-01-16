class CreateJoinTableItemsTags < ActiveRecord::Migration[6.0]
  def change
    create_join_table :items, :tags do |t|
      t.index [:item_id, :tag_id]
    end
  end
end
