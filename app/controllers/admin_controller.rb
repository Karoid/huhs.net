class AdminController < ApplicationController
  layout "admin_application"
  def index
    authorize! :read, Category.where(route: "admin").take
  end
  def show_category
    @category = Category.all
    @board = Board.all
    authorize! :read, Category.where(route: "admin").take
  end
  def show_article
    @article = Rails.cache.fetch("active_article") do
      Article.where(active: true)
    end
    @article_trash = Article.where(active: false)
    @article_trash.where(content: nil).destroy_all
    authorize! :read, Category.where(route: "admin").take
  end
  def show_member
    @nonMember = Member.where(role: 0)
    @member = Member.where('role>0')
    @staff = Member.where('admin="t" or staff="t"')
    @major = Major.all
    authorize! :read, Category.where(route: "admin").take
  end

  def delete_data
    params[:data].each do |id|
      params[:db].camelize.constantize.find(id).destroy
    end
    respond_to do |format|
      format.json { render json: {notice: 'success'} }
    end
    authorize! :read, Category.where(route: "admin").take
  end

  def active_inactive_data
    params[:data].each do |id|
      params[:db].camelize.constantize.find(id).update_attributes(params[:tuple] => params[:bool])
    end
    respond_to do |format|
      format.json { render json: {notice: 'success'} }
    end
    authorize! :read, Category.where(route: "admin").take
  end

  def edit_data
    record = params[:db].camelize.constantize
    record = params[:data][:id] != "" ? record.find(params[:data][:id].to_i) : record.new
    params[:data].each_key {|key|
      params[:data][key] = params[:data][key] == "" ? nil : params[:data][key]
      if key.split(".").length == 1 && key != "id"
        record[key] = params[:data][key]
      elsif key.split(".").length > 1
        forign_record = key.split(".")[0].camelize.constantize.where(key.split(".")[1] => params[:data][key]).take
        record[key.split(".")[0].foreign_key] = forign_record.id
      end
    }
    record.save
    respond_to do |format|
      format.json { render json: {notice: 'success', id: record.id} }
    end
    authorize! :read, Category.where(route: "admin").take
  end

  def getStatistic
    result = []
    hash = Statistic.where(name: params[:name], created_at: 1.week.ago..Date.today).group(:created_at).count
    hash = hash.sort_by { |key,value| key }
    hash.map { |key,value| result.push({day: key, "value": value}) }
    respond_to do |format|
      format.json { render json: value }
    end
    authorize! :read, Category.where(route: "admin").take
  end
end
