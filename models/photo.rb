class Photo < ActiveRecord::Base
  include Paperclip::Glue

  belongs_to :product

  has_attached_file :picture

  delegate :url, :path, to: :picture


  has_attached_file(
    :picture,
    :styles => {
      small: "100x100>",
      medium: "250x250>",
    },
    path: "public/system/photos/:style/:id.:extension",
    :url => "/system/photos/:style/:id.:extension"
  )

  # Explicitly do not validate
  do_not_validate_attachment_file_type :picture
end
