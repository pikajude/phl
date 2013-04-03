module Sass::Script::Functions
  def borderize color
    # darken(desaturate(#e2ffd4, 50), 10) 
    darken(desaturate(color, Sass::Script::Number.new(50)), Sass::Script::Number.new(10))
  end
end
