class MediaController < ApplicationController
  
  def index
    @project = Project.find_by_identifier(params[:id])
    if (User.current!=nil) and (@project.users.include? User.current)!=nil
      @media_files = MediaFile.find_all_by_project_id @project.id, :order=>"created_on DESC" # @project.polls
    else
      render :action=>:not_allowed
    end
  end

  def view
    @media_file = MediaFile.find(params[:id])
    @project = @media_file.project
    if User.current!=nil
      MediaFileView.add_view User.current,@media_file
    end
  end
  
  def add_comment
    comment = MediaFileComment.new
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
    @media.storage_method = MediaFileGlobalSettings.default_storage_method
    if @media.storage_method == "s3"
      @media.s3_bucket = MediaFileGlobalSettings.s3_bucket
    end

    begin
      @media.save!
    rescue
      flash[:error] = "Could not upload file.  Please verify the file size and type."
      redirect_to("/media/index/" + params[:id])
      return
    end

    @media.send_later(:generate_thumb_and_copy_to_destination)
    @media.send_later(:convert_and_copy_to_destination)

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
