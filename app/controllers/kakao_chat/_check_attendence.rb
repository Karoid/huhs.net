require_relative 'variables'
# @@home_presets = ["📚휴즈 위키 홈","📷이미지 업로드","✔오프라인 출석 체크", "🔐*관리자 홈"]
# @@admin_presets = ["🔐공지 작성하기", "🔐회원 등업" ,"🔐오프라인 출석 체크"]

def check_attendence_kakao
    if params[:content] =~ /^\d{4}$/
        @current_user = @login_data.member
        @my_record_list = AttendenceList.where(code: params[:content]).take
        if @my_record_list
          # code exist
          if @my_record_list.start < Time.now && @my_record_list.end >= Time.now
            #code is not expired
            @my_data = {attendence_list_id: @my_record_list.id, user_id: @current_user.id, user_name: @current_user.username}
            if Attendence.where(@my_data).length > 0
                check_attendence_state_message
                @data[:message][:text] +="\n\n 이미 출석이 완료되었습니다\n"
            else
                Attendence.create(@my_data)
                @login_data.update(state:"home")
                home_state_message
                @data[:message][:text] ="출석 성공!\n이벤트 이름: #{@my_record_list.name}\n 홈으로 돌아갑니다."
            end
          else
            #code is expired
            check_attendence_state_message
            @data[:message][:text] +="\n\n출석 실패!\n기한이 만료되었습니다\n"
          end
        else
          #code dosen't exist
          check_attendence_state_message
          @data[:message][:text] +="\n\n출석 실패!\n잘못 입력하셨습니다\n"
        end

    elsif params[:content] == "완료"
        home_state_message
        @login_data.update(state:"home")
    else
        @data[:message][:text] = "4자리 '숫자'를 입력하셔야 합니다\n홈으로 돌아가려면 '완료'라고 입력해주세요!"
    end
end

def check_attendence_state_message
    if @login_data.member.role > 0
        @data = {
            message: {text: "4자리 숫자를 입력해주세요!\n홈으로 돌아가려면 '완료'라고 입력해주세요!"},
            keyboard: {
                type: 'text',
            }
        }
    else
        @login_data.update(state:"home")
        @data = {
            message: {text: "권한이 없습니다. 홈으로 돌아갑니다"},
            keyboard: {
                type: 'buttons',
                buttons: @@home_presets
            }
        }
    end
end
