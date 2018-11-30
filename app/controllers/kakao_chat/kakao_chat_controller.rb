class KakaoChat::KakaoChatController < ApplicationController
    require_relative 'variables'
    load File.expand_path('../home.rb',__FILE__)

    def keyboard
        render :json => {
            :type => "buttons",
            :buttons => ["◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]
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

        render 'kakao_chat/accept_api'
    end

    private

    def before_active_message
        @data[:message][:text] = "휴즈넷에 본인 이메일로 로그인 하여 기기 #{params[:user_key]}를 허용해주세요"
        @data[:keyboard][:type] = "buttons"
        @data[:keyboard][:buttons] = ["✔ 인증 확인하기","✘ 인증 요청 해제하기"]
        @data[:message][:message_button] = {
            label: "휴즈넷 접속",
            url: "http://huhs.net/accept_api"
        }

        if params[:content] == "✘ 인증 요청 해제하기"
            @login_data.destroy
            @data[:message][:text] = "해제했습니다. 다시 본인의 이메일을 입력하세요"
            @data[:keyboard][:type] = "text"
        end
    end

    def login_success
        @login_data.update(state:"home") if params[:content] =~ /휴즈넷 봇 홈으로 돌아가기/

        case @login_data.state
        when "home"
            home
        when "wiki"
            wiki
        when Regexp.new("^image_upload")
            image_upload
        when "check_attendence"
            check_attendence_kakao
        when Regexp.new("^admin")
            admin
        end

    end
end
