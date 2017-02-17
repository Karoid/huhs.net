# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 반드시 Member password를 바꾸어야 한다
# config/initializers/rails_db 의 password, 여기 admin의 password를 바꿔줘라!
def writeolddata(model,doc)
  @article = model.new
  @article.member_id = 1234567
  @article.member_name = doc.at('nick_name').text
  @article.created_at = doc.at('regdate').text.to_time
  @article.updated_at = doc.at('last_update').text.to_time
  @article.title = doc.at('title').text #제목
  @article.content = ""
  @article.content += "글쓴이: "+doc.at('nick_name').text+"<br>" #글쓴이
  if doc.at('uploaded_count').text != '0'
    @article.content += "첨부 갯수: "+doc.at('uploaded_count').text+"<br>" #첨부갯수
    @attach.each do |att|
      if att.at('upload_target_srl').text == doc.at('document_srl').text
        @article.content += '<a href="'+att.at("uploaded_filename").text[1..-1]+'" class="attach">'+att.at("source_filename").text+'</a><br>'
      end
    end
  end
  @article.content += doc.at('content').text.gsub('src="files/', 'src="/files/').gsub('src="./files/', 'src="/files/').html_safe #내용물
  @article.save
  return @article.id
end
def writegallery(doc,article_id)
  if !(@article.content.include? "img") && doc.at('uploaded_count').text != '0'
    @attach.each do |att|
      fileName = att.at("uploaded_filename").text[1..-1].gsub('src="files/', 'src="/files/').gsub('src="./files/', 'src="/files/')
      if File.exist?(Dir.pwd+ "/public"+fileName) && att.at('upload_target_srl').text == doc.at('document_srl').text
        Uploadfile.create(
          article_id: article_id,
          public_id: nil,
          format: "file",
          url: fileName,
          resource_type: nil
        )
        @article.content += '<img src="'+fileName+'">'
      end
    end
    @article.save
  end
end
#Major
Major.create(department: "미등록", name:"미등록", id: 0);
Major.create(department: "공과대학", name:"건축학부");
Major.create(department: "공과대학", name:"자원환경공학과");
Major.create(department: "공과대학", name:"유기나노공학과");
Major.create(department: "공과대학", name:"에너지공학과");
Major.create(department: "공과대학", name:"전기·생체공학부");
Major.create(department: "공과대학", name:"전기공학전공");
Major.create(department: "공과대학", name:"생체공학전공");
Major.create(department: "공과대학", name:"건축공학부");
Major.create(department: "공과대학", name:"융합전자공학부");
Major.create(department: "공과대학", name:"기계공학부");
Major.create(department: "공과대학", name:"미래자동차공학과");
Major.create(department: "공과대학", name:"화공생명공학부");
Major.create(department: "공과대학", name:"화학공학과");
Major.create(department: "공과대학", name:"생명공학과");
Major.create(department: "공과대학", name:"건설환경공학과");
Major.create(department: "공과대학", name:"정보시스템학과");
Major.create(department: "공과대학", name:"원자력공학과");
Major.create(department: "공과대학", name:"컴퓨터공학부");
Major.create(department: "공과대학", name:"컴퓨터전공");
Major.create(department: "공과대학", name:"소프트웨어전공");
Major.create(department: "공과대학", name:"도시공학과");
Major.create(department: "공과대학", name:"신소재공학부");
Major.create(department: "공과대학", name:"산업공학과");
Major.create(department: "의과대학", name:"의예과");
Major.create(department: "의과대학", name:"의학과");
Major.create(department: "인문과학대학", name:"국어국문학과");
Major.create(department: "인문과학대학", name:"중어중문학과");
Major.create(department: "인문과학대학", name:"영어영문학과");
Major.create(department: "인문과학대학", name:"독어독문학과");
Major.create(department: "인문과학대학", name:"사학과");
Major.create(department: "인문과학대학", name:"철학과");
Major.create(department: "인문과학대학", name:"수행인문학부");
Major.create(department: "사회과학대학", name:"정치외교학과");
Major.create(department: "사회과학대학", name:"사회학과");
Major.create(department: "사회과학대학", name:"미디어커뮤니케이션학과");
Major.create(department: "사회과학대학", name:"관광학부");
Major.create(department: "자연과학대학", name:"수학과");
Major.create(department: "자연과학대학", name:"물리학과");
Major.create(department: "자연과학대학", name:"화학과");
Major.create(department: "자연과학대학", name:"생명과학과");
Major.create(department: "정책과학대학", name:"정책학과");
Major.create(department: "정책과학대학", name:"행정학과");
Major.create(department: "법과대학", name:"법학과");
Major.create(department: "경제금융대학", name:"경제금융학부");
Major.create(department: "경영대학", name:"경영학부");
Major.create(department: "경영대학", name:"파이낸스경영학과");
Major.create(department: "사범대학", name:"교육학과");
Major.create(department: "사범대학", name:"교육공학과");
Major.create(department: "사범대학", name:"국어교육과");
Major.create(department: "사범대학", name:"영어교육과");
Major.create(department: "사범대학", name:"수학교육과");
Major.create(department: "사범대학", name:"응용미술교육과");
Major.create(department: "생활과학대학", name:"의류학과");
Major.create(department: "생활과학대학", name:"식품영양학과");
Major.create(department: "생활과학대학", name:"실내건축디자인학과");
Major.create(department: "음악대학", name:"성악과");
Major.create(department: "음악대학", name:"작곡과");
Major.create(department: "음악대학", name:"피아노과");
Major.create(department: "음악대학", name:"관현악과");
Major.create(department: "음악대학", name:"국악과");
Major.create(department: "예술·체육대학", name:"체육학과");
Major.create(department: "예술·체육대학", name:"스포츠산업학과");
Major.create(department: "예술·체육대학", name:"연극영화학과");
Major.create(department: "예술·체육대학", name:"관현악과");
Major.create(department: "국제학부", name:"국제학과");
Major.create(department: "간호학부", name:"간호학과");
Major.create(department: "산업융합학부", name:"응용시스템전공");
Major.create(department: "산업융합학부", name:"정보융합전공");
#Member
Member.create(username: "관리자", email: 'huhs@huhs.net', password: 'kk1111',tel:'01000000000', admin: true, role:2)
#Member.create(username: "정승호", email: 'shj5508@naver.com',senior_number:34, password: 'kk1111',tel:'01000000000', admin: false, role:2)
  #Test Data
=begin
  Member.create(username: "송성국", email: '133@huhs.net',senior_number:33, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송정안", email: '132@huhs.net',senior_number:32, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송태용", email: '131@huhs.net',senior_number:31, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송승훈", email: '130@huhs.net',senior_number:30, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송주성", email: '129@huhs.net',senior_number:29, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송태호", email: '128@huhs.net',senior_number:33, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송고인", email: '127@huhs.net',senior_number:32, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송용석", email: '126@huhs.net',senior_number:31, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송상오", email: '125@huhs.net',senior_number:30, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "송성호", email: '124@huhs.net',senior_number:29, password: 'kk1111',tel:'01000000000', admin: false, role:0);
  Member.create(username: "김성국", email: '33@huhs.net',senior_number:33, password: 'kk1111',tel:'01000000000', admin: false, role:1);
  Member.create(username: "권정안", email: '32@huhs.net',senior_number:32, password: 'kk1111',tel:'01000000000', admin: false, role:1);
  Member.create(username: "이태용", email: '31@huhs.net',senior_number:31, password: 'kk1111',tel:'01000000000', admin: false, role:1);
  Member.create(username: "이승훈", email: '30@huhs.net',senior_number:30, password: 'kk1111',tel:'01000000000', admin: false, role:1);
  Member.create(username: "용주성", email: '29@huhs.net',senior_number:29, password: 'kk1111',tel:'01000000000', admin: false, role:3);
  Member.create(username: "신태호", email: '28@huhs.net',senior_number:33, password: 'kk1111',tel:'01000000000', admin: false, role:1);
  Member.create(username: "성고인", email: '27@huhs.net',senior_number:32, password: 'kk1111',tel:'01000000000', admin: false, role:3);
  Member.create(username: "장용석", email: '26@huhs.net',senior_number:31, password: 'kk1111',tel:'01000000000', admin: false, role:3);
  Member.create(username: "유상오", email: '25@huhs.net',senior_number:30, password: 'kk1111',tel:'01000000000', admin: false, role:3);
  Member.create(username: "신성호", email: '24@huhs.net',senior_number:29, password: 'kk1111',tel:'01000000000', admin: false, role:3);
=end
#Category
Category.create(route: 'introduce', name: '휴즈 소개')
Category.create(route: 'huhslife', name: '게시판')
Category.create(route: 'photo', name: '사진첩', default: "/board/photo/gallery")
Category.create(route: 'addon', name: '편의기능',read_level:1)
Category.create(route: 'admin', name: '관리자 페이지',read_level:100 , default: "/admin")
#Board
Category.where(route: 'introduce').take.boards.create(route: 'history', name: '연혁', show_last: true,show_comment:false)
Category.where(route: 'introduce').take.boards.create(route: 'staff', name: '임원단 소개', show_last: true,show_comment:false)
Category.where(route: 'introduce').take.boards.create(route: 'song', name: '회가', show_last: true,show_comment:false)
Category.where(route: 'introduce').take.boards.create(route: 'rules', name: '회칙', show_last: true,show_comment:false)
Category.where(route: 'huhslife').take.boards.create(route: 'notice', name: '공지사항', show_last: false, read_level:1)
Category.where(route: 'huhslife').take.boards.create(route: 'free', name: '자유 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'huhslife').take.boards.create(route: 'member', name: '회원 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'huhslife').take.boards.create(route: 'graduate', name: 'HAS 게시판', show_last: false, read_level:3, write_level:3)
Category.where(route: 'huhslife').take.boards.create(route: 'problems', name: '디버깅 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'photo').take.boards.create(route: 'gallery', name: '사진첩', show_last: false, template: "board/showPhoto", read_level:1, write_level:2)
if RockScissorsPaper
Category.where(route: 'addon').take.boards.create(route: 'rsp', name: '가위바위보', show_last: true, template: "/game/rsp", read_level:1, write_level:100)
end
if WikiPage
  Category.where(route: 'addon').take.boards.create(route: 'wiki', name: '휴즈위키', show_last: true, template: "/wiki", read_level:1, write_level:100)
end
#Article
Board.where(route: 'history').take.articles.create(
content: '<p>HUHS history</p><p><br></p><p>1982년 &nbsp;10월 28일 제 1회 정기집회, 창립일</p><p>1982년 &nbsp;11월 14일 제 1회 정기총회</p><p>1982년 &nbsp;12월　　　전국대학 컴퓨터 동아리 연합서클(UNICOSA)가입</p><p><br></p><p>1983년 &nbsp; 4월　　　동아리방 배정, 1차 교육실시</p><p>1983년 &nbsp; 5월　　　제1회전시회-컴퓨터전시회</p><p>1983년 &nbsp;10월 29일 제1회 창립기념행사</p><p><br></p><p>1984년 &nbsp; 8월　　　공청회 개최</p><p><br></p><p>1986년 &nbsp; 5월 &nbsp; &nbsp; &nbsp;공대 컴퓨터실(comby)운영</p><p>1986년 &nbsp; 8월 &nbsp; &nbsp; &nbsp;동문회 발족 및 동문회칙제정</p><p>1986년 &nbsp;10월 &nbsp; &nbsp; &nbsp;제1회 동문회총회 개최</p><p><br></p><p>1987년 &nbsp; 6월 &nbsp; &nbsp; &nbsp;회칙개정</p><p><br></p><p>1988년 &nbsp; 8월 &nbsp; &nbsp; &nbsp;제3회 한건교환체육대회</p><p>1988년 &nbsp; 9월 &nbsp; &nbsp; &nbsp;프로콤과 프로그램 협력제작</p><p>　　　　　 　 &nbsp; &nbsp; UNICOSA 회원으로 올림픽 자원봉사</p><p>1988년 &nbsp;11월 &nbsp; &nbsp; &nbsp;공개 PC강좌</p><p><br></p><p>1989년 &nbsp; 4월 &nbsp; &nbsp; &nbsp;제1회 프로그램공모전</p><p>　　　　　 　 &nbsp; &nbsp; 공개PC강좌(중급)</p><p><br></p><p>1991년 제10회 &nbsp; &nbsp; 정기총회</p><p><br></p><p>1992년 &nbsp; 5월 &nbsp; &nbsp; &nbsp;제10회전시회-프로그램전시회</p><p>　　　　 &nbsp; 　 &nbsp; &nbsp; (이하 03년까지의 전시회는 프로그램 전시회라 명한다)</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;6월 &nbsp; &nbsp; &nbsp;회칙개정</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 10월 &nbsp; &nbsp; &nbsp;10회 창립기념행사</p><p><br></p><p>2002년 &nbsp; 2월 &nbsp;6일 huhs.net 서비스 개시</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;5월 &nbsp; &nbsp; &nbsp;제20회 프로그램 전시회</p><p>　　　 &nbsp;11월 &nbsp;2일 제20회 창립기념행사</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 11월 28일 회칙개정</p><p><br></p><p>2003년 &nbsp; 1월 &nbsp;4일 휴즈피아 웹진발표</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;3월 &nbsp; &nbsp; &nbsp;마이크로소프트사 컴퓨터 잡지 투고 계약</p><p><br></p><p>2007년 &nbsp; 5월 11일 제600회 정기집회</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 10월 27일 제25회 창립기념행사 및 HUHSPIA 발간</p><p>&nbsp; &nbsp; &nbsp; &nbsp; 11월 29일 회칙개정</p>',
title: '기존 연혁',member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 32기 융합전자공학부 박종훈",title: "2013년 2학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 30기 컴퓨터전공 전호근<Br>총무 32기 융합전자공학부 박종훈",title: "2014년 1학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 30기 컴퓨터전공 전호근<Br>총무 32기 융합전자공학부 박종훈",title: "2014년 2학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 <Br>총무 34기 경영학과 김준우",title: "2015년 1학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 34기 건설환경공학과 정승호<Br>부회장 34기 관광학부 배시연<Br>총무 35기 융합전자공학부 신태호<Br>섭외부장 35기 유기나노공학과 함형준<Br>기술부장 공석<br>서기 공석<Br>회계 35기 수학과 김성범<Br>신입기수 기장 35기 융합전자공학부 이보림",title: "2015년 2학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 35기 유기나노공학과 함형준<Br>부회장 35기 융합전자공학부 이보림<Br>총무 34기 건설환경공학과 정승호<Br>섭외부장 35기 융합전자공학부 엄다은<Br>기술부장 35기 융합전자공학부 신태호<Br>홍보부장 34기 식품영양학과 이유경<Br>서기 35기 정책학과 조영연<Br>회계 32기 건설환경공학과 유건희<Br>동문위원 32기 경영학과 김수겸<Br><Br><strong>학기 중 임원직 보궐로 교체</strong><Br>총무 35기 건설환경공학과 최관<Br>서기 36기 건설환경공학과 정기호",title: "2016년 1학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'staff').take.articles.create(content: "회장 35기 유기나노공학과 함형준<Br>부회장 35기 기계공학부 이제희<Br>총무 35기 건설환경공학과 최관<Br>섭외부장 35기 융합전자공학부 이연수<Br>기술부장 35기 융합전자공학부 신태호<Br>홍보부장 34기 식품영양학과 이유경<Br>서기 겸 회계 36기 융합전자공학부 서지민<Br>동문위원 32기 경영학과 김수겸<Br>신입기수 기장 36기 사회학과 라대한",title: "2016년 2학기 임원",member_id: 1, member_name:"임원")
Board.where(route: 'song').take.articles.create(content: "<div>Huhs song</div><div><br></div><div>바람부는 날에도 눈내리는 날에도</div><div><br></div><div>우리들 함께 있다면 언제나 좋아라</div><div><br></div><div>태양이 져버려도 달빛이 없는 밤에도</div><div><br></div><div>우리들 함께 가는 길 어디나 밝아라</div><div><br></div><div>타오르는 젊음이 여기에 모두 모이면</div><div><br></div><div>반짝이는 저 별속엔 우리의 꿈이(랄랄랄라)</div><div><br></div><div>바람부는 날에도 눈내리는 날에도</div><div><br></div><div>우리들 함께 있다면 언제나 좋아라</div><div><br></div><div>(랄랄랄라 랄랄라 랄랄랄라 랄랄라)</div><div><br></div><div>(랄랄랄라라 랄라라 랄랄랄랄랄랄라~ 랄라~)</div>",title: "songs", member_id: 1234567, member_name:"임원")
Board.where(route: 'rules').take.articles.create(
content: '<p>과학기술의 발전과 빠르게 변모하는 세계의 주역이 되고자<span lang=\"EN-US\">,&nbsp;</span>그 핵심이 되는 컴퓨터의 중요성을 인식하고 컴퓨터의 자체 연구개발과 컴퓨터 인구의 저변 확대를 꾀하여 인류의 복지와 행복에 이바지하며<span lang=\"EN-US\">,&nbsp;</span>회원들 상호간의 참다운 인간관계를 도모함을 창립 정신으로 하는 한양대학교 컴퓨터 클럽은 진리 탐구와 인간적인 모임의 장이 되길 염원하면서<span>&nbsp;</span><span lang=\"EN-US\">1982</span>년<span>&nbsp;</span><span lang=\"EN-US\">9</span>월<span>&nbsp;</span><span lang=\"EN-US\">14</span>일에 제정되고<span lang=\"EN-US\">, 2015</span>년<span>&nbsp;</span><span lang=\"EN-US\">11</span>월<span>&nbsp;</span><span lang=\"EN-US\">27</span>일에<span>&nbsp;</span><span lang=\"EN-US\">8</span>차 개정하였다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">1&nbsp;</span>장<span lang=\"EN-US\">&nbsp;&nbsp;</span>총 강<span lang=\"EN-US\">&nbsp;</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">1&nbsp;</span>조 본 회는 한양대학교 컴퓨터클럽<span lang=\"EN-US\">(Huhs : Hanyang University Hard &amp; Software)</span>이라 칭한다<span lang=\"EN-US\">.&nbsp;</span>이하 본 회라 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">2&nbsp;</span>조 본 회는 학교법인 한양대학교에 등록된 순수한 학술단체로서<span lang=\"EN-US\">&nbsp;</span>하드웨어와 소프트웨어 및 모바일 디바이스 자체 연구개발과 활용 및 관련 지식의 대외적 확대를 목적으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">3&nbsp;</span>조 본 회는 본부를 한양대학교 내에 둔다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">4&nbsp;</span>조 본 회는 <span lang=\"EN-US\">1982</span>년 <span lang=\"EN-US\">10</span>월 <span lang=\"EN-US\">28</span>일을 창립일로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">5&nbsp;</span>조 본 회는 <span lang=\"EN-US\">1981</span>학번을 <span lang=\"EN-US\">1</span>기로 칭하며<span lang=\"EN-US\">,&nbsp;</span>학번에 따라 기수를 정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">6&nbsp;</span>조 본 회는 다음과 같은 활동을 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>컴퓨터의 연구 개발 및 활용에 힘쓴다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>컴퓨터 관련 지식의 대외적 확대를 도모한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>회원 상호간의 참다운 인간관계를 도모한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>타 대학의 컴퓨터 단체 및 연구 단체와 유대를 도모한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>올바른 컴퓨터 문화의 확산에 힘쓴다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">2&nbsp;</span>장<span lang=\"EN-US\">&nbsp;&nbsp;</span>회 원</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">7&nbsp;</span>조 본 회는 준회원<span lang=\"EN-US\">,&nbsp;</span>정회원<span lang=\"EN-US\">,&nbsp;</span>동문회원<span lang=\"EN-US\">,&nbsp;</span>명예회원으로 구성된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>준회원은 한양대학교 서울 캠퍼스 재학생 및 휴학생으로서 입회원서를 작성한 자로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>정회원은 준회원으로서 객관적 평가를 반드시 받고 임원회에서 인정한 자로 하며<span lang=\"EN-US\">,&nbsp;</span>정회원 승격 시기는 한 학기를 준회원으로 지낸 다음으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>동문회원은 정회원 졸업생으로서 동문회에서 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>명예회원은 본 회의 활동에 지대한 공헌을 한 자로 임원회에서 인정한 자로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">8&nbsp;</span>조 준회원은 다음의 의무와 권리를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>일정회비를 내야하며<span lang=\"EN-US\">,&nbsp;</span>본 회가 주관하는 집회와 각종 행사 및 부서 활동에 참여하여야 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>기재 사용의 권리를 갖되<span lang=\"EN-US\">,&nbsp;</span>이를 올바르게 사용할 의무를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>기초 교육을 받을 의무를 갖고<span lang=\"EN-US\">,&nbsp;</span>학습을 목적으로 한 모임에 참여할 권리를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>선거권을 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">9&nbsp;</span>조 정회원은 다음의 의무와 권리를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>정회원은 준회원의 모든 의무와 권리를 갖는다<span lang=\"EN-US\">.&nbsp;</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>본 회가 주관하는 집회와 각종 행사 및 부서 활동을 주도해야 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>학습을 목적으로 한 모임을 조직하고<span lang=\"EN-US\">,&nbsp;</span>이에 참여할 권리를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>피선거권 및 후보자 추천권을 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">10</span>조 동문회원은 본 회의 활동이 활성화되도록 힘써야 하며 자체 규범에 따른다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">11</span>조 명예회원은 본 회의 활동이 활성화되도록 힘써야 하며 자체 규범에 따른다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">12</span>조 임원회 결정에 대한 규정은 다음과 같다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>모든 회원은 임원회 결정을 따라야 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>임원회 결정에 이의가 있을 경우에는 정회원 <span lang=\"EN-US\">1/5&nbsp;</span>이상의 동의를 얻어 서면으로 임원회에 청구하고<span lang=\"EN-US\">,&nbsp;</span>임원회는 이를 재심사하여야 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>임원회의 재심사 결정에 이의가 있을 경우에는 정회원 <span lang=\"EN-US\">1/3&nbsp;</span>이상의 동의를 얻어 서면으로 임원회에 청구하고<span lang=\"EN-US\">,&nbsp;</span>임원회는 이의 사항을 투표에 부쳐 정회원의 재적인원 과반수 출석에 출석인원 과반수 찬성으로 가부를 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">13</span>조 정회원에서 준회원의 강등은 다음의 제반 사항에 따라 임원회에서 결정한다<span lang=\"EN-US\">.&nbsp;</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>정당한 사유 없이 당 학기 <span lang=\"EN-US\">1/3</span><span lang=\"EN-US\">&nbsp;</span>이상 집회에 불참하고 회비 <span lang=\"EN-US\">1</span>학기 이상 미납자를 대상으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>강등의 결정 및 공시 시기는 학기당 한 번으로 임원회에서 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">14</span>조 회원의 재 승격은 다음의 제반 사항에 따라 임원회에서 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>당 학기 <span lang=\"EN-US\">1/3&nbsp;</span>이상 집회에 참석하고<span lang=\"EN-US\">,&nbsp;</span>미납한 회비 및 당 학기 회비를 완납한 자를 대상으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>재승격의 결정 및 공시 시기는 학기당 한 번으로 임원회에서 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">15</span>조 회원이 다음과 같은 사유의 문제를 일으켰을 시 징계위원회를 열 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>본 회 활동에 비협조적인 자<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>고의로 기물을 파손한 자<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>공금 남용이나 본 회의 비품을 무단 방출한 자<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>동아리의 분위기를 저해하는 자<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>기타 징계가 필요하다고 임원회에서 인정된 자<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">16</span>조 징계위원회는 임원회로 구성된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>의결권은 회장단이 가진다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">17</span>조 징계위원회는 다음과 같은 활동을 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>소집은 정회원이 요청 할 수 있으며<span lang=\"EN-US\">,&nbsp;</span>소집 결정권은 임원회에 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>징계 수준을 논의한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>징계 대상자와 관련자의 소명을 듣는 절차를 가져야 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>징계 수준을 결정한 뒤 징계 대상자에 통보한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>징계위원회는 징계가 완료됨과 동시에 해산한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##6.&nbsp;</span>징계의 결과는 공식석상에서 공표함을 원칙으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">18</span>조 징계의 수준은 다음과 같다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>경고</p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>학기 중 <span lang=\"EN-US\">1</span>달 이하의 활동정지</p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>제명</p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>기타 징계위원회에서 필요하다고 판단한 징계</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">19</span>조 징계의 항소 절차는 다음과 같다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>징계위원회 결정에 이의가 있을 경우에는 정회원 <span lang=\"EN-US\">1/5&nbsp;</span>이상의 동의를 얻어 서면으로 징계위원회에 청구하고<span lang=\"EN-US\">,&nbsp;</span>징계위원회는 이를 재심사할 의무가 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>징계위원회의 재심사 결정에 이의가 있을 경우에는 정회원 <span lang=\"EN-US\">1/3&nbsp;</span>이상의 동의를 얻어 서면으로 임원회에 청구하고<span lang=\"EN-US\">,&nbsp;</span>징계위원회는 이의 사항을 투표에 부쳐 정회원의 재적인원 과반수 출석에 출석인원 과반수로 결정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">20</span>조 탈퇴의 의사가 있는 자는 임원회에 통보하고 탈퇴할 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">3&nbsp;</span>장<span lang=\"EN-US\">&nbsp;&nbsp;</span>임원 및 조직</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">21</span>조 본 회는 다음과 같은 임원을 둔다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회장은 <span lang=\"EN-US\">1</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>부회장은 <span lang=\"EN-US\">1</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>총무는 <span lang=\"EN-US\">1</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>기술부장<span lang=\"EN-US\">,&nbsp;</span>홍보부장<span lang=\"EN-US\">,&nbsp;</span>섭외부장은 각 <span lang=\"EN-US\">1</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">22</span>조 회장단은 회장<span lang=\"EN-US\">,&nbsp;</span>부회장<span lang=\"EN-US\">,&nbsp;</span>총무로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">23</span>조 임원회는 회장<span lang=\"EN-US\">,&nbsp;</span>부회장<span lang=\"EN-US\">,&nbsp;</span>총무 그리고 각 부의 부장<span lang=\"EN-US\">,&nbsp;</span>회계<span lang=\"EN-US\">,&nbsp;</span>서기<span lang=\"EN-US\">,&nbsp;</span>기장<span lang=\"EN-US\">,&nbsp;</span>동문위원<span lang=\"EN-US\">,&nbsp;</span>스터디장으로 구성된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">24</span>조 회장은 본 회를 대표하여 제반 활동을 관장하고<span lang=\"EN-US\">,&nbsp;</span>본회 활동에 절대적인 책임과 권한을 대행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">25</span>조 부회장은 회장을 보좌하고<span lang=\"EN-US\">,&nbsp;</span>회장 부재시 책임과 권한을 대행하며<span lang=\"EN-US\">,&nbsp;</span>본 회에 관련된 사이트의 운영을 맡는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">26</span>조 총무는 공식 행사를 진행하고 회원관리 및 재정관리 등의 제반운영 사무를 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>총무를 보좌하는 회계와 서기를 둔다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>회계는 회비 징수 및 금전 관리를 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>서기는 회의록을 작성하며 집회 시 출석을 점검한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">27</span>조 부장은 그 부를 대표하며 부원을 관리하고 그 부서활동에 절대적인 책임과 권한을 가진다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">28</span>조 본 회는 부서로 기술부<span lang=\"EN-US\">,&nbsp;</span>홍보부<span lang=\"EN-US\">,&nbsp;</span>섭외부를 둔다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>기술부는 스터디 및 기술축적<span lang=\"EN-US\">,&nbsp;</span>자료축적 등의 업무와 기타 행사의 제반 기술적 업무를 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>홍보부는 동아리의 홍보 활동을 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>섭외부는 대내<span lang=\"EN-US\">&middot;</span>외의 섭외활동을 담당하며 회원 상호간의 친목을 도모한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>각 부는 차장을 둘 수 있으며<span lang=\"EN-US\">,&nbsp;</span>차장은 부장 부재 시 위임받은 권한을 대행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>각 부는 필요한 경우에 부속기관을 둘 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">29</span>조 기장은 회장단의 차기 회원을 대표하고 그 기의 권익과 각 기장 간의 연계를 도모한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">30</span>조 동문위원은 재학생과 동문회원 간의 연계와 교류를 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">31</span>조 스터디장은 회원의 수요에 따라 스터디 진행을 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">4&nbsp;</span>장<span>&nbsp;</span><span lang=\"EN-US\">&nbsp;</span>운영 및 행사</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">32</span>조 본 회의 집회는 정기총회<span lang=\"EN-US\">,&nbsp;</span>임시총회<span lang=\"EN-US\">,&nbsp;</span>정기집회<span lang=\"EN-US\">,&nbsp;</span>임시집회<span lang=\"EN-US\">,&nbsp;</span>임원회의<span lang=\"EN-US\">,&nbsp;</span>부서 회의로 구분된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>정기총회는 부득이한 경우를 제외하고는 <span lang=\"EN-US\">11</span>월 마지막주 중에 개최하며<span lang=\"EN-US\">,&nbsp;</span>회장단 선거<span lang=\"EN-US\">,&nbsp;</span>회칙개정<span lang=\"EN-US\">,&nbsp;</span>사업보고 및 결산<span lang=\"EN-US\">,&nbsp;</span>심의 등을 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>임시총회는 정기총회에 상당하는 업무처리 시 임원회에서 소집한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>정기집회는 부득이한 경우를 제외하고는 학기 중 매주 <span lang=\"EN-US\">1</span>회 개최하며<span lang=\"EN-US\">,&nbsp;</span>그 주의 행사와 활동 상황을 보고 및 토론한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>임시집회는 정기집회를 제외하고<span lang=\"EN-US\">,&nbsp;</span>그에 상당하는 업무로 소집의 필요가 있을 때 임원회에서 소집한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>임원회의는 한 달에 <span lang=\"EN-US\">1</span>회 정기적인 개최를 원칙으로 하며<span lang=\"EN-US\">,&nbsp;</span>그 외 임원소집의 필요가 있을 때 회장이 소집한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##6.&nbsp;</span>부서 회의는 부장이 부서 활동을 위해 소집한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">33</span>조 회장단의 피선거권<span lang=\"EN-US\">,&nbsp;</span>추천권 은 정회원에 한하고<span lang=\"EN-US\">,&nbsp;</span>선거권은 모든 회원에 부여한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">34</span>조 회장단의 입후보는 임원회에서 부득이한 경우를 제외하고는 정기총회 <span lang=\"EN-US\">10</span>일 전부터 <span lang=\"EN-US\">7</span>일 동안 등록을 받으며<span lang=\"EN-US\">,&nbsp;</span>총회 전 <span lang=\"EN-US\">3</span>일간 공시한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회장의 입후보는 후보 본인이나 추천인이 정회원 <span lang=\"EN-US\">1/4&nbsp;</span>이상의 동의를 받아 서명을 첨부하여 등록한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>부회장의 입후보는 후보 본인이나 추천인이 정회원 <span lang=\"EN-US\">1/5&nbsp;</span>이상의 동의를 받아 서명을 첨부하여 등록한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>총무의 입후보는 후보 본인이나 추천인이 정회원 <span lang=\"EN-US\">1/5&nbsp;</span>이상의 동의를 받아 서명을 첨부하여 등록한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>회장단 입후보의 복수등록을 할 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">35</span>조 회장단은 정기총회에서 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회장단은 각각 정회원 제적 과반수 출석에 과반수 찬성의 무기명 투표로 선출된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>과반수 찬성을 받은 자가 없을 경우 상위 다 득표자 <span lang=\"EN-US\">2</span>명에 한하여 재투표하여 최다 득표자를 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>회장단의 임기는 전 학기부터 후 학기까지 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">36</span>조 부장은 전임자의 추천을 받아 신임 회장단이 동의함으로써 선출되며<span lang=\"EN-US\">,&nbsp;</span>임기는 전 학기부터 후 학기까지 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">37</span>조 회계와 서기는 전임자 및 신임 총무가 추천하여 신임 회장단이 동의함으로써 선출된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회계와 서기의 임기는 총무의 임기와 같다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">38</span>조 기장은 임시총회에서 정회원 <span lang=\"EN-US\">3</span>명 이상의 추천을 받아 입후보하여 선출된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>기장은 회장단 기의 차기 회원 제적 과반수 출석에 출석인원 과반수 찬성의 무기명 투표로 선출된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>과반수이상의 찬성을 받은 자가 없을 경우 상위 다 득표자 <span lang=\"EN-US\">2</span>명에 한하여 재투표하여 최다 득표자로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>기장의 임기는 후 학기로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">39</span>조 동문위원은 전임자의 추천을 받아 신임 회장단이 동의함으로써 선출되며<span lang=\"EN-US\">,&nbsp;</span>임기는 전 학기부터 후 학기까지 한다<span lang=\"EN-US\">.&nbsp;</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">40</span>조 스터디장은 전임자 및 신임 기술부장의 추천을 받아 회원의 수요에 맞춰서 스터디를 진행하는 사람이며<span lang=\"EN-US\">,&nbsp;</span>임기는 스터디가 진행되는 학기로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">41</span>조 회장 부재 시에는 부회장<span lang=\"EN-US\">,&nbsp;</span>총무<span lang=\"EN-US\">,&nbsp;</span>각부의 부장 순으로 권한을 대행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">42</span>조 임원회 구성원의 궐위 시에는 다음 사항을 따른다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회장이나 부회장<span lang=\"EN-US\">,&nbsp;</span>총무의 궐위 시에는 잔여 임기가 <span lang=\"EN-US\">6</span>개월 이상일 때는 임시 총회를 개최하여 선출하며<span lang=\"EN-US\">, 6</span>개월 미만일 때는 권한 대행의 순으로 수행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>부장의 궐위 시에는 회장단에서 새로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>회계와 서기의 궐위 시에는 회장단에서 새로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>기장의 궐위 시에는 회장단이 정회원 및 차기 정회원 내에서 <span lang=\"EN-US\">1</span>명을 추천 받아 회장단에서 새로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>동문 위원의 궐위 시에는 회장단에서 새로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##6.&nbsp;</span>스터디장의 궐위 시에는 회장단이 새로 선출한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">43</span>조 본 회는 집회 외에 다음과 같은 행사를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>창립기념행사를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>학술강연회 및 강습회를 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>자체 정규 교육을 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">5&nbsp;</span>장<span>&nbsp;</span><span lang=\"EN-US\">&nbsp;</span>재 정</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">44</span>조 본 회는 정기회비<span lang=\"EN-US\">,&nbsp;</span>각계 보조금 및 찬조금을 재원으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">45</span>조 회비의 용도<span lang=\"EN-US\">,&nbsp;</span>재정의 결정은 임원회에서 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">46</span>조 본 회의 재정 집행은 회계가 담당한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>제<span>&nbsp;</span><span lang=\"EN-US\">6&nbsp;</span>장<span lang=\"EN-US\">&nbsp;&nbsp;</span>회칙 개정</p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">47</span>조 회칙 개정은 임원회 또는<span lang=\"EN-US\">,&nbsp;</span>정회원 <span lang=\"EN-US\">1/3&nbsp;</span>이상이 회칙 개정의 의사가 있을 때 회칙개정위원회를 발족하고 회칙 개정 초안을 작성<span lang=\"EN-US\">,&nbsp;</span>회부한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">48</span>조 회칙개정위원회는 다음과 같이 구성된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>기당 정회원 <span lang=\"EN-US\">1</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>임원회에서는 회장을 포함하여 <span lang=\"EN-US\">4</span>명으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>회칙개정위원회에서 필요하다고 인정된 자로 <span lang=\"EN-US\">2</span>명 이내로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>회칙개정위원회는 개정 위원 <span lang=\"EN-US\">2/3&nbsp;</span>이상 출석으로 개정안을 심의할 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">49</span>조 회칙개정위원회는 다음과 같은 활동을 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##1.&nbsp;</span>회칙개정위원회는 임원회의 요청에 의해 발족된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##2.&nbsp;</span>회칙 개정과 관련된 모임을 갖는다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##3.&nbsp;</span>회칙 개정 초안을 회부 <span lang=\"EN-US\">15</span>일 이내에 수정 보완하여 최종 개정안을 공시한다<span lang=\"EN-US\">.&nbsp;</span>단<span lang=\"EN-US\">,&nbsp;</span>공시 기간은 <span lang=\"EN-US\">4</span>일 이상으로 한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##4.&nbsp;</span>회칙 개정안 의결을 위한 총회 개최를 임원회에 요구하고<span lang=\"EN-US\">,&nbsp;</span>임원회는 이를 총회에 상정한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p><span lang=\"EN-US\">##5.&nbsp;</span>회칙개정위원회는 회칙 개정안이 총회에 상정됨과 동시에 해산된다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p><span lang=\"EN-US\">&lt;&nbsp;</span>부 칙<span lang=\"EN-US\">&gt;</span></p><p>&nbsp;</p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">1&nbsp;</span>조 이 회칙은 공고된 날로부터 효력을 발생한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">2&nbsp;</span>조 이 회칙은 발기인 일동이 <span lang=\"EN-US\">1982</span>년 <span lang=\"EN-US\">9</span>월 <span lang=\"EN-US\">15</span>일에 공고 시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">3&nbsp;</span>조 회칙에 명시되지 않은 사항은 통상 관례 및 임원회 결정에 따른다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">4&nbsp;</span>조 임원회 및 각 부는 이 회칙에 위배되지 아니하는 범위 내에서 자체 규범을 둘 수 있다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">5&nbsp;</span>조 이 개정된 회칙은 <span lang=\"EN-US\">1983</span>년 <span lang=\"EN-US\">9</span>월 <span lang=\"EN-US\">1</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">6&nbsp;</span>조 이 개정된 회칙은 <span lang=\"EN-US\">1987</span>년 <span lang=\"EN-US\">6</span>월 <span lang=\"EN-US\">3</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">7&nbsp;</span>조 이 개정된 회칙은 <span lang=\"EN-US\">1991</span>년 <span lang=\"EN-US\">6</span>월 <span lang=\"EN-US\">5</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">8&nbsp;</span>조 이 개정된 회칙은 <span lang=\"EN-US\">1996</span>년 <span lang=\"EN-US\">5</span>월 <span lang=\"EN-US\">30</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">9&nbsp;</span>조 이 개정된 회칙은 <span lang=\"EN-US\">1997</span>년 <span lang=\"EN-US\">11</span>월 <span lang=\"EN-US\">20</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">10</span>조 이 개정된 회칙은 <span lang=\"EN-US\">2002</span>년 <span lang=\"EN-US\">(</span>총회 날짜<span lang=\"EN-US\">)</span>에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">11</span>조 이 개정된 회칙은 <span lang=\"EN-US\">2007</span>년 <span lang=\"EN-US\">11</span>월 <span lang=\"EN-US\">29</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p><p>&nbsp;</p><p>제 <span lang=\"EN-US\">12</span>조 이 개정된 회칙은 <span lang=\"EN-US\">2015</span>년 <span lang=\"EN-US\">11</span>월 <span lang=\"EN-US\">27</span>일에 공고<span lang=\"EN-US\">,&nbsp;</span>시행한다<span lang=\"EN-US\">.</span></p>',
title: '2015년 11월 27일 개정안',member_id: 1, member_name:"임원")
  #Old huhsnet write
  @boardxml1 = File.open("old_migration_data/docs/documents1.xml") { |f| Nokogiri::XML(f) }
  @boardxml1 = @boardxml1.search('//xe_documents')
  @attach = File.open("old_migration_data/docs/attach.xml") { |f| Nokogiri::XML(f) }
  @attach = @attach.search('//xe_files')
    @boardxml1.each do |doc|
      #공지사항:238,자유게시판: 5793, 회원게시판: 160, 임원회의록: 166
      case doc.at('module_srl').text
      when '238'
        model = Board.where(route:'notice').take.articles
        writeolddata(model,doc)
      when '5793'
        model = Board.where(route:'free').take.articles
        writeolddata(model,doc)
      when '160'
        model = Board.where(route:'member').take.articles
        writeolddata(model,doc)
      when '161'
        model = Board.where(route:'gallery').take.articles
        article_id = writeolddata(model,doc)
        writegallery(doc, article_id)
      end
    end
