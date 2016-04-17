class CreateArticleCategoryRelationships < ActiveRecord::Migration
  def change
    create_table :article_category_relationships do |t|
      t.integer :article_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
