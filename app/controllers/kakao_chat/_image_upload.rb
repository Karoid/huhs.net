require_relative 'variables'

def image_upload
    case @login_data.state
    when 'image_upload'
        image_upload_home
    when Regexp.new("^image_upload#image_upload_photo")
        image_upload_photo
    when Regexp.new("^image_upload#image_upload_profile")
        image_upload_profile
    end
end

def image_upload_home
    if params[:content] == @@home_presets[1]
        image_upload_state_message
    elsif params[:content] == @@image_upload_preset[0]
        @login_data.update(state: @login_data.state + "#image_upload_photo")
        image_upload_photo_state_message
    elsif params[:content] == @@image_upload_preset[1]
        @login_data.update(state: @login_data.state + "#image_upload_profile")
        image_upload_profile_state_message
    else
        image_upload_state_message
        @data[:message][:text] += "\n*주어진 보기를 선택하세요*"
    end
end

def image_upload_photo
    if params[:type] == "photo"
        if @login_data.state.split("#")[2]
            @login_data.update(state: @login_data.state + "#"+ params[:content])
            image_upload_photo_state_message
        else
            image_upload_photo_state_message
            @data[:message][:text] = "★제목을 작성해야 합니다!★\n" + @data[:message][:text]
        end
    elsif params[:content] == "완료" && @login_data.state.split("#")[2]
        # 게시글 작성
        title = @login_data.state.split("#")[2]
        before_img_urls = @login_data.state.split("#")[3..-1]
        if @login_data.state.split("#").length > 3
            Thread.new do
                img_urls = []
                article = Board.where(route: 'gallery').take.articles.create(content: "",title: title,member_id: @login_data.member.id, member_name: @login_data.member.username)
                before_img_urls.each do |url|
                    sended_msg = Cloudinary::Uploader.upload(url,{use_filename: true,folder: article.id.to_s})
                    img_urls.push(sended_msg['url'])
                    image_upload_write_model(sended_msg,article.id)
                end
                content = "<img src='" + img_urls.join("'/></br><img src='") + "'/>"
                article.update(content: content)
            end
            @login_data.update(state: "home")
            home_state_message
            @data[:message][:text] += "\n업로드 요청을 서버에 보냈습니다!"
        else
            image_upload_photo_state_message
            @data[:message][:text] = "★사진을 첨부해야 합니다★\n" + @data[:message][:text]
        end
    elsif @login_data.state.split("#").length == 2
        # 제목 입력
        @login_data.update(state: @login_data.state + "#"+ params[:content])
        image_upload_photo_state_message
    elsif params[:content] == "취소" && @login_data.state.split("#")[2]
        home_state_message
        @login_data.update(state:"home")
    else
        image_upload_photo_state_message
        @data[:message][:text] += "\n\n의미없는 문자를 받았습니다 이미지를 업로드하세요"
    end
end

def image_upload_profile
    if params[:type] == "photo"
        @login_data.update(state: @login_data.state + "#https://res.cloudinary.com/demo/image/fetch/w_300,h_300,c_fill/"+ params[:content])
        image_upload_profile_state_message
    elsif params[:content] == "예" && @login_data.state.split("#")[2]
        # 프로필 업로드
        Thread.new do
            sended_msg = Cloudinary::Uploader.upload(@login_data.state.split("#")[3],{use_filename: true,unique_filename: false,overwrite:true,folder: "member/#{@login_data.member.id}"})
            image_upload_write_model(sended_msg,0)
            @login_data.member.update(image_url: sended_msg['url'])
        end
        @login_data.update(state: "home")
        home_state_message
        @data[:message][:text] += "\n업로드 요청을 서버에 보냈습니다\n조만간 프로필이 바뀝니다!"
    elsif params[:content] == "아니요" && @login_data.state.split("#")[2]
        @login_data.update(state:"image_upload#image_upload_profile")
        image_upload_profile_state_message
    elsif params[:content] == "취소"
        home_state_message
        @login_data.update(state:"home")
    else
        image_upload_profile_state_message
        @data[:message][:text] += "\n\n의미없는 문자를 받았습니다 이미지를 업로드하세요"
    end
end

def image_upload_state_message
    @data = {
        message: {
                text: "[[기능 선택]]\n프로필 사진을 바꾸거나 휴즈넷 사진첩에 업로드하세요"
            },
        keyboard: {
            type: "buttons",
            buttons: @@image_upload_preset+ ["◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]
        }
    }
end

def image_upload_photo_state_message
    url = @login_data.state.split("#")
    if url.length == 2
        @data = {
            message: {
                text: "[[사진첩 제목 입력]]\n사진을 업로드하려면 우선 게시글 제목을 알려주세요!"
            },
    
            keyboard: {
                type: 'text'
            }
        }
    else
        @data = {
            message: {
                text: "[[사진첩 사진 업로드 방법]]\n + 버튼 > 원하는 사진 선택 > 사진 전송\n모두 추가한 후에는 '완료'혹은 '취소'를 입력해 마무리합니다\n\n[[업로드 예정 사진]]\n제목:"+url[2] + "\n URL:" + url[3..-1].join("\nURL: ")
            },
            keyboard: {
                type: 'text'
            }
        }
    end
end

def image_upload_profile_state_message
    url = @login_data.state.split("#")
    if url.length == 3
        @data = {
            message: {
                text: "이 사진으로 하시겠습니까?",
                photo: {
                    url: url[2],
                    width: 300,
                    height: 300
                }
            },
            keyboard: {
                type: "buttons",
                buttons: ["예", "아니요", "◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]
            }
        }
    else
        @data = {
            message: {
                text: "[[프로필 사진 업로드 방법]]\n + 버튼 > 원하는 사진 선택 > 사진 전송\n만약 취소하려면 '취소'라고 입력하세요"
            },
            keyboard: {
                type: 'text'
            }
        }
    end
end

def image_upload_write_model(sended_msg,article_id)
    Uploadfile.create(
        article_id: article_id,
        public_id: sended_msg['public_id'],
        format: sended_msg['format'],
        url: sended_msg['url'],
        resource_type: sended_msg['resource_type'])
end