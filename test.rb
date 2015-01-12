require 'rmagick'

image = Magick::Image.read("./public/images/destr.jpg").first

text = Magick::Draw.new
  text.annotate(image, 0, 0, 0, 0, "TEST") {
  self.gravity = Magick::CenterGravity
  self.pointsize = 30
  self.stroke = 'transparent'
  self.fill = '#ff0000'
  self.font_weight = Magick::BoldWeight
  self.font_style = Magick::NormalStyle
}

image.write "test.jpg"