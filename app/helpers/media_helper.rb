module MediaHelper
  
  def number_of_views(media_file)
    nviews = media_file.media_file_views.size
    views_string = case nviews
      when 0 then "no views"
      when 1 then "1 view"
      else "#{nviews} views"
    end
 
    if nviews>=1 and media_file.can_be_edited_by? User.current
      unique_viewers = media_file.unique_viewers_list
      views_string = views_string + " (viewed by "
      unique_viewers.each_index do |i|
        viewer = unique_viewers[i]
        if i>0
          views_string = views_string + ","
        end
        views_string = views_string + "#{viewer.login}"
      end
      views_string = views_string + ")"
    end
    views_string
  end

  def number_of_comments(media_file)
    ncomments = media_file.media_file_comments.size
    comments_string = case ncomments
      when 0 then "no comments"
      when 1 then "1 comment"
      else "#{ncomments} views"
    end
    comments_string
  end



end
