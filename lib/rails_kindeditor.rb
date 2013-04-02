require 'rails_kindeditor/engine'
require 'rails_kindeditor/helper'
require 'carrierwave'
require 'mini_magick'

module RailsKindeditor
  
  mattr_accessor :upload_dir
  @@upload_dir = 'uploads'
  
  mattr_accessor :upload_image_ext
  @@upload_image_ext = %w[gif jpg jpeg png bmp]
  
  mattr_accessor :upload_flash_ext
  @@upload_flash_ext = %w[swf flv]

  mattr_accessor :upload_media_ext
  @@upload_media_ext = %w[swf flv mp3 wav wma wmv mid avi mpg asf rm rmvb]
  
  mattr_accessor :upload_file_ext
  @@upload_file_ext = %w[doc docx xls xlsx ppt htm html txt zip rar gz bz2]
  
  mattr_accessor :image_resize_to_limit
  
  mattr_accessor :items
  @@items = [
        'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'template', 'code', 'cut', 'copy', 'paste',
        'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
        'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
        'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
        'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
        'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
        'flash', 'media', 'insertfile', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
        'anchor', 'link', 'unlink', '|', 'about'
  ]
  
  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end
  
  def self.assets
    Dir[root_path.join('vendor/assets/javascripts/kindeditor/**', '*.{js,css}')].inject([]) do |assets, path|
      assets << Pathname.new(path).relative_path_from(root_path.join('vendor/assets/javascripts'))
    end
  end
  
  def self.upload_store_dir
    dirs = upload_dir.gsub(/^\/+/,'').gsub(/\/+$/,'').split('/')
    dirs.each { |dir| dir.gsub!(/\W/, '') }
    dirs.delete('')
    dirs.join('/')
  end
  
  def self.resize_to_limit
    if !image_resize_to_limit.nil? && image_resize_to_limit.is_a?(Array)
      [image_resize_to_limit[0], image_resize_to_limit[1]]
    else
      [800, 800]
    end
  end
  
  def self.setup
    yield self
  end
  
end