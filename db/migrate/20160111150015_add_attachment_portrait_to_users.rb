class AddAttachmentPortraitToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :portrait
    end
  end

  def self.down
    remove_attachment :users, :portrait
  end
end
