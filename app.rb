$stdout.sync = true

require 'goliath'
require 'rmagick'
# require "base64"
require "open-uri"

class App < Goliath::API
  
  TED = "TED"
  
  use Goliath::Rack::Params
  use(Rack::Static,
    :root => Goliath::Application.app_path("./public"),
    :urls => ['/images', '/index.html', '/index.js', '/index.css']
  )
  
  def response env

    case env['REQUEST_PATH'] 
      when '/'
        [200,{'Content-Type' => "text/html"},File.read("./public/index.html")]
      when '/image'
        raise "Title Missing" unless params['text']
        
        size = params['size'] ? params['size'].to_i : 50
        if params['image_url']
          urlimage = open params['image_url']
          image = Magick::ImageList.new
          image.from_blob(urlimage.read)
        elsif params['image']
          image = Magick::Image.read("./public/images/#{params['image']}").first
        else
          raise "Image Missing"  
        end  
        
        img_width = image.bounding_box.width
        img_height = image.bounding_box.height        
                
        title = params['text'].downcase
        
        draw = Magick::Draw.new
        draw.gravity = Magick::WestGravity
        draw.pointsize = size
        draw.stroke = 'transparent'
        draw.fill = '#000000'
        draw.font_weight = Magick::NormalWeight
        draw.font_style = Magick::NormalStyle
        
        ted_metrics = draw.get_type_metrics TED
        ted_width  = ted_metrics.width
        ted_height  = ted_metrics.height          

        title_metrics = draw.get_type_metrics title
        title_width  = title_metrics.width
        title_height  = title_metrics.height        
        x = (img_width - title_width - ted_width) / 2
        y = (img_height - title_height) / 2
        draw.annotate(image, title_width, title_height, x, y, title) 
        
        draw.fill = '#ff0000'
        draw.font_weight = Magick::BoldWeight        
        draw.annotate(image, ted_width, ted_height, x + title_width, y, TED) 

        [200, {'Content-Type' => "image/jpeg"}, image.to_blob]
    end
  end
end

