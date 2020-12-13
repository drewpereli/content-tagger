class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.text :content, null: false
      t.integer :content_type, null: false, default: 0
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
