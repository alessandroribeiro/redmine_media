class MediaController < ApplicationController
  
  def index
    @project = Project.find_by_identifier(params[:id])
    @media_files = MediaFile.find_all_by_project_id @project.id, :order=>"created_on DESC" # @project.polls
    puts "media_files = #{@media_files}"
  end
  
  def view
    @media_file = MediaFile.find(params[:id])
    @project = @media_file.project
    puts "media_file = #{@media_file}"    
  end
  
  def add_comment
    comment = MediaFileComment.new
    #comment.title = params[:comment][:title]
    comment.body = params[:comment][:body]
    comment.user = User.current
    comment.media_file = MediaFile.find params[:comment][:media_file_id]
    comment.save!
    redirect_to("/media/view/" + params[:comment][:media_file_id])
  end
  
  def upload
    @project = Project.find_by_identifier(params[:id])
    @media = MediaFile.new(params[:original])  
    @media.project = @project
    @media.user = User.current
    @media.converted = false
    if @media.is_audio? or @media.is_flv?
      @media.converted = true
    end
    begin
      @media.save!
    rescue
      flash[:error] = "Could not upload file.  Please verify the file size and type."
      redirect_to("/media/index/" + params[:id])
      return
    end
    
    if @media.is_video_and_needs_conversion?
      @media.send_later(:generate_thumb)
      @media.send_later(:convert)
    end
    if @media.is_flv?
      @media.send_later(:generate_thumb)
    end
    flash[:notice] = "Successfully added media file"
    redirect_to("/media/index/" + params[:id])
  end
  
  def remove
    media_file = MediaFile.find params[:id]
    project = media_file.project
    MediaFile.delete params[:id]
    flash[:notice] = "Successfully removed media file"    
    redirect_to("/media/index/" + project.identifier)
  end
  
  def edit_form
    @media_file = MediaFile.find params[:id]    
    @project = @media_file.project
  end
  
  def update
    @media_file = MediaFile.find params[:id]    
    @project = @media_file.project
    @media_file.update_attributes! params[:media_file]       
    flash[:notice] = "Successfully updated media file"    
    redirect_to("/media/index/" + @project.identifier)   
  end
  
end
