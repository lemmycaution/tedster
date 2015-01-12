$stdout.sync = true

require 'goliath'
require 'rmagick'
# require "base64"
require "open-uri"

class App < Goliath::API
  
  TED = "TED"
  SIZE = 50
  PAD = 4  
  
  use Goliath::Rack::Params
  use(Rack::Static,
    :root => Goliath::Application.app_path("./public"),
    :urls => ['/images', '/index.html']
  )
  
  def response env

    case env['REQUEST_METHOD'] 
      when 'GET'
        [200,{'Content-Type' => "text/html"},File.read("./public/index.html")]
      when 'POST'
        urlimage = open params['image_url']
        image = Magick::ImageList.new 
        image.from_blob(urlimage.read)
        title = params['title'].downcase
        
        text = Magick::Draw.new
        text_ted_metrics = text.get_type_metrics TED
        puts text_ted_metrics
        text.annotate(image, 0, 0, -text_ted_metrics.width*2-PAD, 0, title) {
          self.gravity = Magick::CenterGravity
          self.pointsize = SIZE
          self.stroke = 'transparent'
          self.fill = '#000000'
          self.font_weight = Magick::BoldWeight
          self.font_style = Magick::NormalStyle
        }
        
        text_ted = Magick::Draw.new
        text_metrics = text_ted.get_type_metrics title
        puts text_metrics
        text_ted.annotate(image, 0, 0, text_metrics.width*2+PAD, 0, TED) {
          self.gravity = Magick::CenterGravity
          self.pointsize = SIZE
          self.stroke = 'transparent'
          self.fill = '#ff0000'
          self.font_weight = Magick::BoldWeight
          self.font_style = Magick::NormalStyle
          self.font_family = "Helvetica"
        }        

        [200, {'Content-Type' => "image/jpeg"}, image.to_blob]
    end
  end
end

