module HomeHelper
  def cloudinary_quality(url,transformations)
    iscloudinary = /((http)|(https))\:\/\/res\.cloudinary\.com\//.match(url)
    if iscloudinary
      splited_url = url.split("/")
      return splited_url.insert(splited_url.index("upload")+1,transformations).join("/")
    else
      return url
    end
  end
end
