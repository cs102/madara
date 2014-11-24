class AddUpdatedByToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :updated_by, :integer
  end
end
