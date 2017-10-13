class Uploadfile < ActiveRecord::Base
  belongs_to :article
  def self.destroy_files(article_id)
    destroy_files = Uploadfile.where(article_id: article_id)
    destroy_files.each do |file|
      Thread.new do
        Cloudinary::Uploader.destroy(file.public_id, options = {})
      end
    end
    destroy_files.destroy_all
  end
end
