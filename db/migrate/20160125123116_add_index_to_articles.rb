class AddIndexToArticles < ActiveRecord::Migration
  def change
    add_index :articles, [:user_id, :created_at]
  end
end
