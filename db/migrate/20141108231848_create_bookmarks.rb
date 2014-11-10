class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.text :link
      t.text :title
      t.references :user, index: true
      t.timestamps
    end
    add_index :bookmarks, [:user_id, :created_at]
  end
end
