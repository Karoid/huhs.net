module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end

    def low_quality(url)
      iscloudinary = /((http)|(https))\:\/\/res\.cloudinary\.com\//.match(url)
      return url.split("/").insert(-2,"media_lib_thumb").join("/")
    end
  end
end
