class WikiPagesController < ApplicationController
  before_action :authenticate_member!
  acts_as_wiki_pages_controller

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

end
class Irwi::Formatters::RedCarpet
  def format(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, tables: true,footnotes: true, strikethrough: true, space_after_headers: false)
    markdown.render(text)
  end
end
Irwi.config.user_class_name = "Member"
Irwi.config.formatter = Irwi::Formatters::RedCarpet.new
Irwi.config.paginator = Irwi::Paginators::WillPaginate.new
