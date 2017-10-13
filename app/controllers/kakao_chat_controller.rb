class KakaoChatController < ApplicationController
    @@home_presets = ["휴즈 위키 홈","이미지 업로드","오프라인 출석 체크", "관리자 홈"]
    @@admin_presets = ["공지 작성하기", "회원 등업" ,"오프라인 출석 체크"]
    
    def keyboard
        render :json => {
            :type => "buttons",
            :buttons => ["휴즈넷 봇 홈으로 돌아가기"]
        }
    end
    
    def get_message
        user_key = params[:user_key]
        type = params[:type]
        message = params[:content]
        valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        @login_data = KakaoChatLogin.where(user_key: user_key).take
        @data = {
            :message => {
                :text => "[ERROR] \n서버의 @data 내용이 없습니다. \nSTATE:#{@login_data.state if @login_data} \nMSG:#{params[:content]}"
            },
            :keyboard => {type: "text"}
        }
        
        if @login_data.nil?
            @data[:message][:text] = "로그인이 필요합니다. 휴즈넷 이메일을 입력해주세요!"
            if message =~ valid_email_regex 
                if mem = Member.select(:id).where(email: message).take
                    KakaoChatLogin.find_or_create_by(user_key: user_key, member_id: mem.id, state: "home")
                    before_active_message
                else
                    @data[:message][:text] = "휴즈넷에 존재하지 않는 이메일입니다."
                end
            end
            
        else
            
            if !@login_data.active
                before_active_message
            else
                login_success
            end
        
        end
        
        render :json => @data
    end
    
    def friend_add
        render :status => 200
    end
    
    def friend_out
        render :status => 200
    end
    
    def chat_room_out
        user_key = params[:user_key]
        
        render :status => 200
    end
    
    def accept_api
        authenticate_member!
        @kakao_chat_login = current_member.kakao_chat_logins
        
        if params[:active] == 'true'
            @kakao_chat_login.where(user_key: params[:user_key]).take.update(active: params[:active])
            render :json => {
                :message => 'success'
            }
        elsif params[:active] == 'false'
            @kakao_chat_login.where(user_key: params[:user_key]).take.destroy
            render :json => {
                :message => 'success'
            }
        end
    end
    
    private
    
    def before_active_message
        @data[:message][:text] = "휴즈넷에 로그인 하여 기기 #{params[:user_key]}를 허용해주세요"
        @data[:keyboard][:type] = "buttons"
        @data[:keyboard][:buttons] = ["인증 확인하기"]
        @data[:message][:message_button] = {
            label: "휴즈넷 접속",
            url: "http://huhs.net/accept_api"
        }
    end
    
    def login_success
        @login_data.update(state:"home") if params[:content] == "휴즈넷 봇 홈으로 돌아가기"

        case @login_data.state
        when "home"
            home
        when "wiki"
            wiki
        when Regexp.new("^image_upload")
            image_upload
        when "check_attendence"
            check_attendence
        when "admin"
            admin
        end
        
    end
    
    def home
        case params[:content]
        when @@home_presets[0]
            #휴즈 위키 읽기
            @login_data.update(state:"wiki")
            wiki_state_message
        when Regexp.new("^"+@@home_presets[1])
            #이미지 업로드하기
            @login_data.update(state:"image_upload")
            image_upload_state_message
        when @@home_presets[2]
            #오프라인 출석하기
            #@login_data.update(state:"check_attendence")
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
    
    def wiki
        if (params[:content] =~ /\|제목\|/) || params[:content] =~ Regexp.new(@@home_presets[0])
            wiki_state_message
        elsif params[:content] =~ /#!/
            page = params[:content].split("#!")[1].to_i
            wiki_state_message(page)
        elsif params[:content] == "휴즈넷 봇 홈으로 돌아가기"
            @login_data.update(state:"home")
            home_state_message
        elsif params[:content] == "위키 검색하기"
            @data[:message] = {text: "원하는 검색어를 입력해주세요"}
            @data[:keyboard] = {type: "text"}
        else
            search_result = WikiPage.where("title LIKE ?", "%#{params[:content]}%")
            if search_result.length > 1
                wiki_state_message
                @data[:message][:text] = params[:content]+" 에 대한 검색 결과입니다"
                @data[:keyboard][:buttons] = search_result.select(:title).map{|x| "|제목|"+x.title} + ["위키 검색하기",@@home_presets[0]+'으로 돌아가기','휴즈넷 봇 홈으로 돌아가기']
            elsif search_result.length == 1
                wiki_state_message(0,search_result.take.title)
                @data[:message][:text] = search_result.take.content
            else
                wiki_state_message
                @data[:message][:text] = "검색결과가 없습니다."
            end
            
        end
    end
    
    def admin
        if params[:content] == @@admin_presets[0]
            # 공지 등록하기
            @data = {
                message: {text: "[[공지 등록하는 법]]\n이 글과 같이 [[제목]]을 작성한 후에 줄바꿈을 하고 내용을 적어주시면 됩니다.\n홈으로 돌아가려면 '#{@@home_presets[2]}'이라고 쳐주세요!"},
                keyboard: {
                    type: 'text'
                }
            }
        elsif params[:content] == @@admin_presets[1]
            # 회원 등업
            admin_role_upgrade_message
        elsif params[:content] == @@admin_presets[2]
            # 출석 체크
            @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: [@@home_presets[3]+'으로 돌아가기']
                }
            }
        elsif params[:content] =~ Regexp.new(@@home_presets[2])
            admin_state_message
        else
            if params[:content] =~ /\[\[.*\]\]/
                # 공지 등록하기
                title = params[:content].match(/\[\[.*\]\]/)[0][2..-3]
                content = params[:content].split(/\[\[.*\]\]/).join().gsub("\n","</br>")
                Board.where(route: 'notice').take.articles.create(content: content,title: title,member_id: @login_data.member.id, member_name: @login_data.member.username)
                admin_state_message
                @data[:message][:text] = "등록이 완료되었습니다!\n 관리자 홈으로 돌아갑니다."
            elsif params[:content] =~ /^\|회원\|\d#/
                #회원 등업
                member_id = params[:content].split(/\||#/)[2].to_i
                member_data = Member.select(:id,:email,:username,:senior_number,:tel).find(member_id).attributes.map{|k,v| k+":"+v.to_s+"\n"}.join()
                @data = {
                message: {text: member_data},
                    keyboard: {
                        type: 'buttons',
                        buttons: ['!준회원 등업#'+member_id.to_s,'!정회원 등업#'+member_id.to_s,'!탈퇴시키기#'+member_id.to_s,'!졸업회원 등업#'+member_id.to_s,@@home_presets[2]+'으로 돌아가기','휴즈넷 봇 홈으로 돌아가기']
                    }
                }
            elsif params[:content] =~ /^!준회원 등업#/
                member_id = params[:content].split("#")[1]
                Member.find(member_id).update(role:1)
                admin_role_upgrade_message
            elsif params[:content] =~ /^!정회원 등업#/
                member_id = params[:content].split("#")[1]
                Member.find(member_id).update(role:2)
                admin_role_upgrade_message
            elsif params[:content] =~ /^!졸업회원 등업#/
                member_id = params[:content].split("#")[1]
                Member.find(member_id).update(role:3)
                admin_role_upgrade_message
            elsif params[:content] =~ /^!탈퇴시키기#/
                member_id = params[:content].split("#")[1]
                Member.find(member_id).destroy
                admin_role_upgrade_message
            end
        end
        
        return admin_authenticate
    end
    
    def image_upload
        if params[:content] == @@home_presets[2]
            image_upload_state_message
        elsif params[:type] == "photo" && @login_data.state.split("#")[1]
            @login_data.update(state: @login_data.state + "#"+ params[:content])
            image_upload_state_message
        elsif params[:content] == "사진 업로드 종료" && @login_data.state.split("#")[1]
            # 게시글 작성
            @login_data.update(state: "home")
            home_state_message
            title = @login_data.state.split("#")[1]
            before_img_urls = @login_data.state.split("#")[2..-1]
            if !before_img_urls.empty?
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
        else
            # 제목 입력
            @login_data.update(state: @login_data.state + "#"+ params[:content])
            image_upload_state_message
        end
    end
    
    def home_state_message
        img = @login_data.member.image_url
        @data[:message][:text] = "[[로그인 상태]]\nEmail: #{@login_data.member.email}\nName: #{@login_data.member.username}"
        @data[:keyboard] = {
            type: "buttons",
            buttons: @@home_presets
        }
        if img[0] != '/'
            @data[:message][:photo] = {
                url: img,
                width: 100,
                height: 100
            }
        end
    end
    
    def wiki_state_message(page=0,title='')
        content = "읽고싶은 휴즈 위키의 글을 골라주세요!"
        first_button = page > 0 ? ["이전#!"+(page-1).to_s] : ["위키 검색하기"]
        if params[:content] =~ /\|제목\|/
            title = params[:content].split("|제목|")[1]
            content = WikiPage.where(title: title).take.content
        end
        @data = {
            message: {
                text: content,
                message_button: {
                    label: "휴즈위키 접속",
                    url: "http://huhs.net/wiki/" + URI.escape(title)
                }
            },
            
            keyboard: {
                type: 'buttons',
                buttons: first_button + 
                WikiPage.select(:title).limit(9).offset(9*page).map{|x| "|제목|"+x.title} + ['다음#!'+(page+1).to_s,'휴즈넷 봇 홈으로 돌아가기']
            }
        }
    end
    
    def image_upload_state_message
        if params[:content] == @@home_presets[1]
            @data = {
                message: {
                    text: "사진을 업로드하려면 우선 게시글 제목을 알려주세요!"
                },
                
                keyboard: {
                    type: 'text'
                }
            }
        else
            url = @login_data.state.split("#")
            @data = {
                message: {
                    text: "[[업로드 예정 사진]]\n제목:"+url[1] + "\n URL:" + url[2..-1].join("\nURL: ")
                },
                keyboard: {
                    type: 'buttons',
                    buttons: ["사진 업로드 종료"]
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
    
    def check_attendence_state_message
        @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: ['휴즈넷 봇 홈으로 돌아가기']
                }
            }
    end
    
    def admin_state_message
        @data = {
            message: {
                text: "관리자 홈 접속완료\nEmail: #{@login_data.member.email}\nName: #{@login_data.member.username}",
                message_button: {
                    label: "관리자 페이지 접속",
                    url: "http://huhs.net/admin"
                }
            },
            
            keyboard: {
                type: 'buttons',
                buttons: @@admin_presets + ["휴즈넷 봇 홈으로 돌아가기"]
            }
        }
    end
    
    def admin_role_upgrade_message
        # 회원 등업
        non_members = Member.where(role: 0)
        @data = {
            message: {text: "현재 #{non_members.length}명의 회원이 가입 대기중입니다."},
            keyboard: {
                type: 'buttons',
                buttons: non_members.map{|x| '|회원|'+x.id.to_s+'#'+x.username} + [@@home_presets[2]+'으로 돌아가기']
            }
        }
    end
    
    def admin_authenticate
        unless @login_data.member.admin || @login_data.member.staff
            @login_data.update(state:"home")
            home_state_message
            @data[:message][:text] = "당신은 관리자가 아닙니다.\n 홈으로 돌아갑니다"
        end
    end
end
