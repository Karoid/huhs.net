class AdminController < ApplicationController
  layout "admin_application"
  def index
    authorize! :read, Category.where(route: "admin").take
  end
  def change_index

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
    @staff = Member.where(staff: true, admin:false) + Member.where(staff: false, admin:true) + Member.where(staff: true, admin:true)
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
    params[:data].keys.each {|key|
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

  def member_statistic

  end

  def getStatistic
    result = []
    hash = Statistic.where(name: params[:name], created_at: 1.week.ago..Date.today).group(:created_at).count
    hash = hash.sort_by { |key,value| key }
    hash.map { |key,value| result.push({day: key, "value": value}) }
    respond_to do |format|
      format.json { render json: result }
    end
    authorize! :read, Category.where(route: "admin").take
  end

  def getStatisticOfMember
    result = []
    hash = Member.all.group(:role).count
    hash = hash.sort_by { |key,value| key }
    hash.map { |key,value| result.push({role: key, "value": value}) }
    respond_to do |format|
      format.json { render json: result }
    end
    authorize! :read, Category.where(route: "admin").take
  end

  def edit_index_image
    sended_msg = Cloudinary::Uploader.upload(params[:file],{:width => 1200, :height => 1000, :crop => :limit, public_id: 'slider-bg',unique_filename: false,overwrite:true,folder: "index"})
    if upload = Uploadfile.where(public_id: 'index/slider-bg')[0]
      upload.update(url: sended_msg['url'])
    else
      Uploadfile.create(
        article_id: 0,
        public_id: sended_msg['public_id'],
        format: sended_msg['format'],
        url: sended_msg['url'],
        resource_type: sended_msg['resource_type'])
    end
    render json: {url: sended_msg['url']}
  end
end
