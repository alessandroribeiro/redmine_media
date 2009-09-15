require 'redmine'

Redmine::Plugin.register :redmine_media do
  name 'Redmine Media plugin'
  author 'Alessandro Coelho Ribeiro'
  description 'This is a plugin to support video and audio files on redmine'
  version '0.0.1'
  
  project_module :media do
    permission :view, :media => :index
    permission :remove, :media => :remove
    permission :upload, :media => :upload
  end
  
  menu :project_menu, :media, { :controller => 'media', :action => 'index' }, :caption => 'Media'
  
  # This plugin contains settings
  settings :default => {
    'storage_type' => 'filesystem'
  }, :partial => 'settings/storage_type_settings'

end
  