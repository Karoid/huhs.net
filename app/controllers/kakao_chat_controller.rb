class KakaoChatController < ApplicationController
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
        login_data = KakaoChatLogin.where(user_key: user_key).take
        @keyboard = {type: "text"}
        
        if login_data.nil?
            res = "로그인이 필요합니다. 휴즈넷 이메일을 입력해주세요!"
            if message =~ valid_email_regex 
                if mem = Member.where(email: message)[0]
                    KakaoChatLogin.find_or_create_by(user_key: user_key, member_id: mem.id)
                    res = "휴즈넷에 로그인 하여 기기 #{user_key}를 허용해주세요\nhttp://huhs.net/accept_api"
                    @keyboard[:type] = "buttons"
                    @keyboard[:buttons] = ["인증 확인하기"]
                else
                    res = "휴즈넷에 존재하지 않는 이메일입니다."
                end
            end
            
        else
            
            if !login_data.active
                res = "휴즈넷에 로그인 하여 기기 #{user_key}를 허용해주세요\nhttp://huhs.net/accept_api"
                @keyboard[:type] = "buttons"
                @keyboard[:buttons] = ["인증 확인하기"]
            else
                res = "로그인 완료"
                @keyboard[:type] = "buttons"
                @keyboard[:buttons] = ["휴즈 위키 읽기","이미지 업로드하기", "공지 올리기"]
            end
        
        end
        
        render :json => {
            :message => {
                :text => res
            },
            :keyboard => @keyboard
        }
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
end
