class AddIcodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :icode, :string
  end
end
