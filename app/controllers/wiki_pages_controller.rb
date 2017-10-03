class WikiPagesController < ApplicationController
  before_action :authenticate_member!
  acts_as_wiki_pages_controller

  def show
    return not_allowed unless show_allowed?

    @pages = Irwi.config.paginator.paginate(page_class.select(:id,:title,:path, :updated_at, :updator_id).order('updated_at DESC'), page: params[:page], per_page: 5)

    if params[:json]
       respond_to do |format|
         format.json { render json: make_object_to_json(@pages) }
       end
     else
      render_template(@page.new_record? ? 'no' : 'show')
     end
    
  end

  def all
    @pages = Irwi.config.paginator.paginate(page_class, page: params[:page], per_page: 10)

     if params[:json]
       respond_to do |format|
         format.json { render json: make_object_to_json(@pages) }
       end
     else
      render_template 'all'
     end
  end

  def setup_page
    @page = page_class.find_by_path_or_new(params[:path] || '')
    if params[:page]
      begin
        if params[:page][:id]
          @page = page_class.find_by_id(params[:page][:id])
          @page.path = params[:path]
        end

      rescue
      end
    end
    
  end

  def show_allowed?
    true # Show page to all users
  end

  def history_allowed?
    true # Show history to all users
  end

  def edit_allowed?
    if @page.path == '' && !current_member.admin?
      false
    else
      true
    end
  end

  def destroy_allowed?
    current_member.admin?
      # Allow editing only to admins, and not to root page
  end
    private
    def make_object_to_json(object)
      #AJAX를 위해 view 담기
      @article_page_json = []
      object.each do |value|
        hash = {}
        hash = value.attributes
        hash[:view] = Statistic.where(name: "read_article",target_model:WikiPage, target_id: value.id).length
        hash[:member_name] = Irwi.config.user_class.find(value.updator_id).username
        @article_page_json.push(hash)
      end
      return @article_page_json
    end
end

class Irwi::Formatters::RedCarpet
  def format(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, tables: true,footnotes: true, strikethrough: true, space_after_headers: false)
    markdown.render(text)
  end
end
