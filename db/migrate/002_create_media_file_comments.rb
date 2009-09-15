class CreateMediaFileComments < ActiveRecord::Migration
  def self.up
    create_table :media_file_comments do |t|
      t.column "title", :string
      t.column "body", :string     
      t.column "media_file_id",  :integer 
      t.column "user_id",  :integer 
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end

  end

  def self.down
    drop_table :media_file_comments
    
  end
end
