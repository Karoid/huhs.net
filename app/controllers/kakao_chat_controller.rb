class KakaoChatController < ApplicationController
    @@presets = ["휴즈 위키 읽기","이미지 업로드하기", "공지 올리기"]
    
    def keyboard
        render :json => {
            :type => "buttons",
            :buttons => ["로그인 하기"]
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
                :text => ""
            },
            :keyboard => {type: "text"}
        }
        
        if @login_data.nil?
            @data[:message][:text] = "로그인이 필요합니다. 휴즈넷 이메일을 입력해주세요!"
            if message =~ valid_email_regex 
                if mem = Member.where(email: message).take
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
        case @login_data.state
        when "home"
            home
        when "wiki"
            wiki
        when "image_upload"
            image_upload
        end
        
    end
    
    def home
        case params[:content]
        when @@presets[0]
            #휴즈 위키 읽기
            @login_data.update(state:"wiki")
            wiki_state_message
        when @@presets[1]
            #이미지 업로드하기
            @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: ['홈으로 돌아가기']
                }
            }
        when @@presets[2]
            #공지 업로드하기
            @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: ['홈으로 돌아가기']
                }
            }
        else
            home_state_message
        end
    end
    
    def wiki
        if (params[:content] =~ /\|위키\|/) || params[:content] == @@presets[0]
            wiki_state_message
        elsif params[:content] =~ /#!/
            page = params[:content].split("#!")[1].to_i
            wiki_state_message(page)
        elsif params[:content] == "홈으로 돌아가기"
            @login_data.update(state:"home")
            home_state_message
        elsif params[:content] == "위키 검색하기"
            @data[:message] = {text: "원하는 검색어를 입력해주세요"}
            @data[:keyboard] = {type: "text"}
        else
            search_result = WikiPage.where("title LIKE ?", "%#{params[:content]}%")
            if search_result.length > 1
                wiki_state_message
                @data[:message][:text] = search_result.take.content
                @data[:buttons] = search_result.map{|x| "|위키|"+x.title} + ["위키 검색하기",'휴즈 위키 읽기','홈으로 돌아가기']
            elsif search_result.length == 1
                wiki_state_message(0,search_result.take.title)
                @data[:message][:text] = search_result.take.content
            else
                wiki_state_message
                @data[:message][:text] = "검색결과가 없습니다."
            end
            
        end
    end
    
    def home_state_message
        img = @login_data.member.image_url
        @data[:message][:text] = "[[로그인 상태]]\nEmail: #{@login_data.member.email}\nName: #{@login_data.member.username}"
        @data[:keyboard] = {
            type: "buttons",
            buttons: @@presets
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
        if params[:content] =~ /\|위키\|/
            title = params[:content].split("|위키|")[1]
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
                WikiPage.limit(9).offset(9*page).map{|x| "|위키|"+x.title} + ['다음#!'+(page+1).to_s,'홈으로 돌아가기']
            }
        }
    end
end
