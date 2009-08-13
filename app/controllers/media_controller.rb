class MediaController < ApplicationController

  def index
    @project = Project.find_by_identifier(params[:id])
    if params[:commit]=="Create"
      @media = MediaFile.new(params[:original])  
      @media.project = @project
      @media.user = User.current
      @media.converted = false
      if @media.is_audio? or @media.is_flv?
        @media.converted = true
      end
      @media.save!
      
      if @media.is_avi?
        @media.generate_thumb
        @media.convert
      end
     if @media.is_flv?
        @media.generate_thumb
      end

    end
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
  
  def remove
  end

end
