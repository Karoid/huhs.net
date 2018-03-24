require_relative 'variables'
require_relative '_wiki'
load File.expand_path('../_image_upload.rb',__FILE__)
require_relative '_check_attendence'
require_relative '_admin'

# @@home_presets = ["📚휴즈 위키 홈","📷이미지 업로드","✔오프라인 출석 체크", "🔐*관리자 홈"]
# @@admin_presets = ["🔐공지 작성하기", "🔐회원 등업" ,"🔐오프라인 출석 체크"]


def home
    case params[:content]
    when @@home_presets[0]
        #휴즈 위키 읽기
        @login_data.update(state:"wiki")
        wiki_state_message
    when @@home_presets[1]
        #이미지 업로드하기
        @login_data.update(state:"image_upload")
        image_upload_state_message
    when @@home_presets[2]
        #오프라인 출석하기
        @login_data.update(state:"check_attendence")
        check_attendence_state_message
    when @@home_presets[3]
        #관리자 설정
        @login_data.update(state:"admin")
        admin_state_message
        admin_authenticate
    else
        home_state_message
    end
end

def home_state_message
    img = cloudinary_quality(@login_data.member.image_url,"w_300,h_300")
    @data[:message][:text] = "[[로그인 상태]]\nEmail: #{@login_data.member.email}\nName: #{@login_data.member.username}"
    @data[:keyboard] = {
        type: "buttons",
        buttons: @@home_presets
    }
    if img[0] != '/'
        @data[:message][:photo] = {
            url: img,
            width: 300,
            height: 300
        }
    end
end

def cloudinary_quality(url,transformations)
  iscloudinary = /((http)|(https))\:\/\/res\.cloudinary\.com\//.match(url)
  if iscloudinary
    splited_url = url.split("/")
    return splited_url.insert(splited_url.index("upload")+1,transformations).join("/")
  else
    return url
  end
end