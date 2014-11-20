class AddAdminToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :admin, :boolean, default: false
  end
end
