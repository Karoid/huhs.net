class WikiPagesController < ApplicationController
  before_action :authenticate_member!
  acts_as_wiki_pages_controller
end
Irwi.config.user_class_name = "Member"
Irwi.config.formatter = Irwi::Formatters::RedCarpet.new
