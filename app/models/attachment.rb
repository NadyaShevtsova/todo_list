class Attachment < ActiveRecord::Base
  require 'file_size_validator'

  belongs_to :comment

  validates :file, presence: true#, file_size: { maximum: 10.megabytes.to_i }

  mount_uploader :file, FileUploader


  def filename
    File.basename(file.url).truncate(22)
  end

  def to_jq_uploader
    {
      name: filename,
      url: file_url,
      id: id
    }
  end
end
