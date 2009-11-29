class CreateTableMediaFileGlobalSettings < ActiveRecord::Migration
  def self.up
    create_table :media_file_global_settings do |t|
      t.column :name, :string
      t.column :value, :string
    end
  end

  def self.down
    drop_table :media_file_global_settings
  end
end
