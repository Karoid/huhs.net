require_relative 'variables'

def wiki
    if (params[:content] =~ /\|제목\|/) || params[:content] =~ Regexp.new(@@home_presets[0])
        wiki_state_message
    elsif params[:content] =~ /◀|▶/
        page = params[:content].split("◀|▶").join().to_i
        wiki_state_message(page)
    elsif params[:content] == "휴즈넷 봇 홈으로 돌아가기"
        @login_data.update(state:"home")
        home_state_message
    elsif params[:content] == "위키 검색하기 ⌕"
        @data[:message] = {text: "원하는 검색어를 입력해주세요"}
        @data[:keyboard] = {type: "text"}
    else
        search_result = WikiPage.where("title LIKE ?", "%#{params[:content]}%")
        if search_result.length > 1
            wiki_state_message
            @data[:message][:text] = params[:content]+" 에 대한 검색 결과입니다"
            @data[:keyboard][:buttons] = search_result.select(:title).map{|x| "|제목|"+x.title} + ["위키 검색하기 ⌕",@@home_presets[0]+'으로 돌아가기','◎ 휴즈넷 봇 홈으로 돌아가기 ◎"]']
        elsif search_result.length == 1
            wiki_state_message(0,search_result.take.title)
            @data[:message][:text] = search_result.take.content
        else
            wiki_state_message
            @data[:message][:text] = "검색결과가 없습니다."
        end

    end
end

def wiki_state_message(page=0,title='')
    content = "읽고싶은 휴즈 위키의 글을 골라주세요!"
    first_button = page > 0 ? ["◀"+(page-1).to_s] : ["위키 검색하기 ⌕"]
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
            WikiPage.select(:title,:updated_at).order('updated_at DESC').limit(9).offset(9*page).map{|x| "|제목|"+x.title} + [(page+1).to_s+ '▶','◎ 휴즈넷 봇 홈으로 돌아가기 ◎']
        }
    }
end