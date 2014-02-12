class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :assetable, polymorphic: true

  delegate :url, to: :attachment

  # validates_presence_of :user

  has_attached_file :attachment,
                    styles: {
                        medium: '66x66^',
                        thumb: '120x120^'},
                    convert_options: {
                        medium: '-gravity center -extent 66x66',
                        thumb: '-gravity center -extent 120x120',
                    }

  before_post_process :skip_for_non_image

  def skip_for_non_image
    attachment_content_type.include? 'image'
  end

  attr_accessible :attachment, :user_id

  def image?
    self.attachment_content_type.include? 'image'
  end

end