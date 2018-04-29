class Statistic < ActiveRecord::Base
  belongs_to :member

  def self.view_count_up(model,id)
    view = Statistic.find_or_initialize_by(name:"read_article", target_model: model, target_id: id)
    count = view.member_id || 0
    view.update(member_id: count + 1)
  end

  def self.view_count(model,id)
    view = Statistic.find_or_initialize_by(name:"read_article", target_model: model, target_id: id)
    return view.member_id || 0
  end

  #name 값의 규칙은 migrate 파일 안에 있습니다
  def self.create(attributes = nil, &block)
    attributes['created_at'] ||= DateTime.now.to_date
    if self.where(attributes, &block).length == 0
      super
    end
  end
end
