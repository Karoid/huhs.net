class Point < ActiveRecord::Base
end
require 'article'
require 'statistic'
require 'wiki_page_version'
class Statistic
  after_save :give_point
  #저장할때 포인트를 줍니다.
  def give_point
    point = Point.where(user_id: self.member_id).take
    case self.name
    when "write_problem"
      article = self.target_model.camelize.constantize.find(self.target_id.to_i)
      if point
        point.point += 1500
        point.save
      else
        Point.create(user_id: self.member_id, point: 6500)
      end
    when "sign_in"
      if point
        point.point += 700
        point.save
      else
        Point.create(user_id: self.member_id, point: 5700)
      end
    end
  end
end
class Article
  after_save :statistic
  #저장할때 포인트를 줍니다.
  def statistic
    if self.board.route == "problems"
      Statistic.create(name: "write_problem", member_id: self.member_id, target_model: "Board", target_id: self.board.id)
    end
  end
end
class WikiPageVersion
  after_save :add_after_commit
  def add_after_commit
    point = Point.where(user_id: self.updator_id).take
    if point
      point.point += 500
      point.save
    else
      Point.create(user_id: self.updator_id, point: 5500)
    end
  end
end
