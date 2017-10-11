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
                if mem = Member.where(email: message)[0]
                    KakaoChatLogin.find_or_create_by(user_key: user_key, member_id: mem.id)
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
        case params[:content]
        when @@presets[0]
            #휴즈 위키 읽기
            @data = {
                message: {
                    text: "읽고싶은 휴즈 위키의 글을 골라주세요!",
                    message_button: {
                        label: "휴즈위키 접속",
                        url: "http://huhs.net/wiki"
                    }
                },
                
                keyboard: {
                    type: 'buttons',
                    buttons: WikiPage.limit(9).offset(0).map{|x| "|위키|"+x.title} + ['다음#1','처음으로']
                }
            }
        when @@presets[1]
            #이미지 업로드하기
            @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: ['처음으로']
                }
            }
        when @@presets[2]
            #공지 업로드하기
            @data = {
                message: {text: "준비중입니다"},
                keyboard: {
                    type: 'buttons',
                    buttons: ['처음으로']
                }
            }
        else
            if params[:content] =~ /\|위키\|/
                title = params[:content].split("|위키|")[1]
                @data[:message][:text] = WikiPage.where(title: title)[0].content
                @data[:keyboard] = {
                    type: "buttons",
                    buttons: @@presets
                }
            elsif params[:content] =~ /다음#/
                page = params[:content].split("다음#")[1].to_i
                @data = {
                    message: {text: "위키 페이지: #{page}"},
                    keyboard: {
                        type: 'buttons',
                        buttons: WikiPage.limit(9).offset(9*page).map{|x| "|위키|"+x.title} + ['다음#'+(page+1).to_s,'처음으로']
                    }
                }
            else
                login_state_message
            end
        end
        
    end
    
    def login_state_message
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
end
