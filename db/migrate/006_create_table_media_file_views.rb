class CreateTableMediaFileViews < ActiveRecord::Migration
  def self.up
    create_table :media_file_views do |t|
      t.column :user_id, :integer 
      t.column :media_file_id, :integer 
      t.column :created_at, :timestamp
    end

  end

  def self.down
    drop_table :media_file_views   
  end
  
  
end
