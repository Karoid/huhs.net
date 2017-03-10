# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 반드시 Member password를 바꾸어야 한다
# config/initializers/rails_db 의 password, 여기 admin의 password를 바꿔줘라!

#Member
Member.create(username: "정승호", email: 'huhs@huhs.net', password: 'kk1111',tel:'01000000000', admin: true, role:2)
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
Category.create(route: 'introduce', name: '커뮤니스 소개')
Category.create(route: 'life', name: '게시판')
Category.create(route: 'photo', name: '사진첩', default: "/board/photo/gallery")
Category.create(route: 'addon', name: '추가기능',read_level:1)
Category.create(route: 'admin', name: '관리자 페이지',read_level:100 , default: "/admin")
#Board
Category.where(route: 'introduce').take.boards.create(route: '', name: '커뮤니스란?', show_last: true,show_comment:false, template: "/#About Us")
Category.where(route: 'introduce').take.boards.create(route: '', name: '우리의 목표', show_last: true,show_comment:false, template: "/#Our Mission")
Category.where(route: 'introduce').take.boards.create(route: '', name: '올해의 계획', show_last: true,show_comment:false, template: "/#Our Plan")
Category.where(route: 'introduce').take.boards.create(route: '', name: '문의', show_last: true,show_comment:false, template: "/#Contact Us")
Category.where(route: 'introduce').take.boards.create(route: 'history', name: '회칙', show_last: true,show_comment:false)
Category.where(route: 'introduce').take.boards.create(route: 'staff', name: '임원진 소개', show_last: true,show_comment:false)
Category.where(route: 'life').take.boards.create(route: 'notice', name: '공지사항', show_last: true, read_level:1)
Category.where(route: 'life').take.boards.create(route: 'free', name: '자유 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'life').take.boards.create(route: 'teach', name: '강의 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'life').take.boards.create(route: 'problems', name: '질문 게시판', show_last: false, read_level:1, write_level:1)
Category.where(route: 'photo').take.boards.create(route: 'gallery', name: '사진첩', show_last: false, template: "board/showPhoto", read_level:1, write_level:2)
if RockScissorsPaper
Category.where(route: 'addon').take.boards.create(route: 'rsp', name: '가위바위보', show_last: true, template: "/game/rsp", read_level:1, write_level:100)
end
if WikiPage
  Category.where(route: 'life').take.boards.create(route: 'wiki', name: '커뮤니스 위키', show_last: true, template: "/wiki", read_level:1, write_level:100)
  WikiPage.create(creator_id:1,updator_id:1,path:'',title:'위키 운영 원칙', content:'본 위키는 회원 여러분들의 개개인을 정의내리고, 추억, 역사를 기록할 수 있는 공간입니다. \r\n\r\n### 위키의 목적\r\n휴즈 위키는 다음의 사항을 주로 담습니다\r\n\r\n* 본 동아리의 현, 전회원\r\n* 본 동아리내에 주로 사용되는 용어\r\n* 본 동아리내에서 일어난 사건\r\n\r\n다음 사항에 해당하지 않는 문서는 **회원명/문서명**으로 특정 회원과 연관지어서 문서를 작성해주시기 바랍니다.\r\n\r\n* 특정인의 별명\r\n* 특정인과 관련된 어떠한 행위\r\n\r\n### 금지사항\r\n다음과 같은 사항은 휴즈위키에서 금하고 있습니다\r\n\r\n* 의도적으로 문서를 훼손하는 **반달리즘**\r\n* 근거 없는 **비난 및 비방**\r\n\r\n위 사항으로 적발시 휴즈위키 일시 사용 금지 및 영구 사용금지될 수 있음을 숙지해주십시오.\r\n\r\n### 글 작성시 유의사항\r\n####본 위키는 실명위키입니다!\r\n따라서 누군가가 불쾌하거나 문제가 될 부분이 있는 경우 주석으로 자신의 증언이라고 적어주셔야 합니다.  \r\n만일 논의를 통해 삭제 결정이 난 이후에도 지속적으로 이전 문서를 복원하는 회원의 경우 **반달리즘으로 규정**하고 위키를 작성할 권한을 일시/영구적으로 박탈당하게 됩미다.\r\n####마크다운 문법으로 작성하셔야 합니다\r\n글은 **html** 과 **[마크다운 문법](https://nolboo.kim/blog/2014/04/15/how-to-use-markdown/)**으로 쉽게 작성될 수 있습니다. 마크다운은 매우 널리 쓰이는 문서 작성법이니 익히시는 것을 추천드립니다^^ \r\n#### 본 위키의 목적에 맞는 문서를 작성하셔야 합니다\r\n앞서 설명한 위키의 목적에 부합하지 않는 문서는 관리자에 의해 수정 및 삭제된 후 복원 금지될 수 있습니다.')
end
#Article
Board.where(route: 'history').take.articles.create(
content: '아직 회칙이 제정되지 않았습니다',
title: '회칙',member_id: 1, member_name:"정승호")
Board.where(route: 'staff').take.articles.create(
content: '대표 정승호\r\n조만간 팀장이 선출될 예정',
title: '1대 임원',member_id: 1, member_name:"정승호")
