require_relative 'variables'
# @@home_presets = ["📚휴즈 위키 홈","📷이미지 업로드","✔오프라인 출석 체크", "🔐*관리자 홈"]
# @@admin_presets = ["🔐공지 작성하기", "🔐회원 등업" ,"🔐오프라인 출석 체크"]

def admin
    @login_data.update(state:"admin") if params[:content] =~ Regexp.new(@@home_presets[3])
    case @login_data.state
    when 'admin'
        if params[:content] == @@admin_presets[0]
            # 공지 등록하기
            @login_data.update(state: 'admin#notice')
            admin_notice_state_message
        elsif params[:content] == @@admin_presets[1]
            # 회원 등업
            @login_data.update(state: 'admin#role_upgrade')
            admin_role_upgrade_state_message
        elsif params[:content] == @@admin_presets[2]
            # 출석 체크
            @login_data.update(state: 'admin#check_attendence')
            admin_check_attendence_state_message
        elsif params[:content] =~ Regexp.new(@@home_presets[3])
            @login_data.update(state: 'admin')
            admin_state_message
        end
    when 'admin#notice'
        if params[:content] =~ /^\[\[.*\]\]/
            # 공지 등록하기
            title = params[:content].match(/^\[\[.*\]\]/)[0][2..-3]
            content = params[:content].split(/^\[\[.*\]\]/).join().gsub("\n","</br>")
            Board.where(route: 'notice').take.articles.create(content: content,title: title,member_id: @login_data.member.id, member_name: @login_data.member.senior_number.to_s + "기 " + @login_data.member.username)
            admin_state_message
            @login_data.update(state: 'admin')
            @data[:message][:text] = "등록이 완료되었습니다!\n #{@@home_presets[3]}으로 돌아갑니다."
        else
            admin_notice_state_message
            @data[:message][:text] += "\n\n양식이 틀렸습니다"
        end
    when 'admin#role_upgrade'
        if params[:content] =~ /^\|회원\|\d+#/
            #회원 등업
            member_id = params[:content].split(/\||#/)[2].to_i
            member_data = Member.select(:id,:email,:username,:senior_number,:tel).find(member_id).attributes.map{|k,v| k+":"+v.to_s+"\n"}.join()
            @data = {
            message: {text: member_data},
                keyboard: {
                    type: 'buttons',
                    buttons: ['!준회원 등업#'+member_id.to_s,'!정회원 등업#'+member_id.to_s,'!탈퇴시키기#'+member_id.to_s,'!졸업회원 등업#'+member_id.to_s,@@home_presets[3]+'으로 돌아가기','◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]']
                }
            }
        elsif params[:content] =~ /^!준회원 등업#/
            member_id = params[:content].split("#")[1]
            Member.find(member_id).update(role:1)
            admin_role_upgrade_state_message
        elsif params[:content] =~ /^!정회원 등업#/
            member_id = params[:content].split("#")[1]
            Member.find(member_id).update(role:2)
            admin_role_upgrade_state_message
        elsif params[:content] =~ /^!졸업회원 등업#/
            member_id = params[:content].split("#")[1]
            Member.find(member_id).update(role:3)
            admin_role_upgrade_state_message
        elsif params[:content] =~ /^!탈퇴시키기#/
            member_id = params[:content].split("#")[1]
            Member.find(member_id).destroy
            admin_role_upgrade_state_message
        end
    when Regexp.new('^admin#check_attendence')
        if params[:content] =~ /◀|▶/
            page = params[:content].split("◀|▶").join().to_i
            admin_check_attendence_state_message(page)
        elsif params[:content] == "!새로운 행사 생성하기"
            @data[:message][:text] = "새로운 행사명을 입력해주세요!\n 돌아가려면 '관리자 홈'이라고 입력하세요"
            @data[:keyboard][:type] = "text"
            @login_data.update(state: "admin#check_attendence#create")
        elsif params[:content] =~ /\d+\..*/
            this_attendence = AttendenceList.select(:id,:name,:code,:user_name).find(params[:content].split(".")[0])
            admin_check_attendence_read_state_message(this_attendence)
        elsif params[:content] =~ /출석자 명단 보기#/
            id = params[:content].split("#")[1]
            this_attendence = AttendenceList.find(id)
            admin_check_attendence_read_state_message(this_attendence)
            @data[:message][:text] = "[[" + this_attendence.name + " 출석자 명단]]\n" +
            Attendence.where(attendence_list_id: id).map{|x| x.user_name + "\n"}.join()
        elsif params[:content] =~ /^출결 10초간 활성화 하기#/
            this_attendence = AttendenceList.find(params[:content].split("#")[1])
            admin_check_attendence_read_state_message(this_attendence)
            this_attendence.update(start: Time.now ,end: Time.now + 10)
            @data[:message][:text] = "10초간 활성화되었습니다."
        elsif params[:content] =~  /^수동으로 출석 해주기#/
            id = params[:content].split("#")[1]
            this_attendence = AttendenceList.find(id)
            admin_check_attendence_read_state_message(this_attendence)
            @data[:message][:text] = "[[" + this_attendence.name + " 출석자 명단]]\n" +
            Attendence.where(attendence_list_id: id).map{|x| x.user_name + "\n"}.join()

            @data[:message][:text] += "\n출석 체크할 이름을 입력해주세요!\n다 입력했으면 '완료'라고 입력해주세요!"
            @data[:keyboard][:type] = "text"
            @login_data.update(state: "admin#check_attendence#check#"+id)
        elsif params[:content] =~ /^행사 삭제하기#/
            @data[:message][:text] = "정말 삭제하시겠습니까?"
            @data[:keyboard] = {type: "buttons", buttons: ["아니요", "예, 삭제하겠습니다#"+params[:content].split("#")[1]]}
        elsif params[:content] =~ /^예, 삭제하겠습니다#/
            this_attendence = AttendenceList.find(params[:content].split("#")[1])
            Attendence.where(attendence_list_id: this_attendence.id).destroy_all
            this_attendence.destroy
            admin_check_attendence_state_message
            @data[:message][:text] = this_attendence.name+ "(이)가 삭제되었습니다."
        else
            if @login_data.state == "admin#check_attendence#create"
                # 제목 입력받기
                schema = {
                    user_id: @login_data.member.id,
                    user_name: @login_data.member.username,
                    name: params[:content],
                    start: Time.now,
                    end: Time.now,
                    code: Random.rand(1000..9999)
                }
                AttendenceList.create(schema)
                admin_check_attendence_state_message
                @login_data.update(state: "admin#check_attendence")
                @data[:message][:text] = "행사 등록 완료!\n" + @data[:message][:text]
            elsif @login_data.state =~ /admin#check_attendence#check#\d+/
                id = @login_data.state.split("#")[3]

                if params[:content] == '완료'

                    @login_data.update(state: 'admin#check_attendence')
                    admin_check_attendence_state_message
                else
                    this_attendence = AttendenceList.find(id)
                    admin_check_attendence_read_state_message(this_attendence)
                    huhs_net_member = Member.where(username: params[:content])
                    if huhs_net_member.length == 1
                        user_id = huhs_net_member.take.id
                    else
                        user_id = nil
                    end

                    Attendence.create({attendence_list_id: id, user_id: user_id, user_name: params[:content]})

                    @data[:message][:text] = "[[" + this_attendence.name + " 출석자 명단]]\n" +
                    Attendence.where(attendence_list_id: id).map{|x| x.user_name + "\n"}.join()
                    @data[:message][:text] += "\n출석 체크할 이름을 입력해주세요!\n다 입력했으면 '완료'라고 입력해주세요!"
                    @data[:keyboard][:type] = "text"
                end

            else
                admin_check_attendence_state_message
            end

        end

    end

    return admin_authenticate
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
            buttons: @@admin_presets + ["◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]
        }
    }
end

def admin_notice_state_message
    @data = {
                message: {text: "[[공지 등록하는 법]]\n이 글과 같이 [[제목]]을 작성한 후에 줄바꿈을 하고 내용을 적어주시면 됩니다.\n홈으로 돌아가려면 '관리자 홈'이라고 쳐주세요!"},
                keyboard: {
                    type: 'text'
                }
            }
end

def admin_role_upgrade_state_message
    # 회원 등업
    non_members = Member.where(role: 0)
    @data = {
        message: {text: "현재 #{non_members.length}명의 회원이 가입 대기중입니다."},
        keyboard: {
            type: 'buttons',
            buttons: non_members.map{|x| '|회원|'+x.id.to_s+'#'+x.username} + [@@home_presets[3]+'으로 돌아가기']
        }
    }
end

def admin_check_attendence_state_message(page=0)
    first_button = page > 0 ? ["◀"+(page-1).to_s] : ["!새로운 행사 생성하기"]

    @data = {
            message: {text: "오프라인 출석체크 행사 목록입니다"},
            keyboard: {
                type: 'buttons',
                buttons: first_button + AttendenceList.select(:name,:id,:created_at).order(created_at: :desc).limit(9).offset(9*page).map{|x| x.id.to_s+"."+x.name} + [(page+1).to_s+ '▶',@@home_presets[3]+'으로 돌아가기']
            }
        }
end

def admin_check_attendence_read_state_message(attendence_list)
    @data[:message][:text] = "[[행사 내용]]\n" + attendence_list.attributes.map{|k,v| k+":"+v.to_s+"\n"}.join()
    @data[:keyboard][:type] = "buttons"
    @data[:keyboard][:buttons] = [attendence_list.name+" 출석자 명단 보기#"+attendence_list.id.to_s, "출결 10초간 활성화 하기#"+attendence_list.id.to_s,"수동으로 출석 해주기#"+attendence_list.id.to_s, "#{@@home_presets[3]}으로 돌아가기","행사 삭제하기#"+attendence_list.id.to_s]
end

def admin_authenticate
    unless @login_data.member.admin || @login_data.member.staff
        @login_data.update(state:"home")
        home_state_message
        @data[:message][:text] = "당신은 관리자가 아닙니다.\n 홈으로 돌아갑니다"
    end
end