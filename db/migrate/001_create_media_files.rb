class CreateMediaFiles < ActiveRecord::Migration
  def self.up
    create_table :media_files do |t|
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string

      t.column "width", :integer  
      t.column "height", :integer
      
      # added by alessandro
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "name", :string
      t.column "description", :string
      t.column "project_id", :integer
      t.column "user_id", :integer      
    end

    # only for db-based files
    # create_table :db_files, :force => true do |t|
    #      t.column :data, :binary
    # end
  end

  def self.down
    drop_table :media_files
    
    # only for db-based files
    # drop_table :db_files
  end
end
