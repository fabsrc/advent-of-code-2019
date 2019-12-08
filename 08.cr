def get_layers(data, width, height)
  data.to_s.chars.map(&.to_i).in_groups_of(width * height)
end

def get_checksum(data, width, height)
  layers = get_layers(data, width, height)
  min_zeros_layer = layers.min_by(&.count(0))
  min_zeros_layer.count(1) * min_zeros_layer.count(2)
end

def decode_image(data, width, height)
  layers = get_layers(data, width, height)
  pixels = layers.transpose.map(&.find(&.!= 2))
  pixels.in_groups_of(width).map(&.join.tr("01", " #")).join("\n")
end

if ARGV.size > 0
  puts get_checksum(ARGV[0], 25, 6)
  puts decode_image(ARGV[0], 25, 6)
end
