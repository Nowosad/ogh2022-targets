rgb_to_lab = function(r){
  wrap(app(r, function(i) convertColor(i, "sRGB",  "Lab", scale.in = 255)))
}