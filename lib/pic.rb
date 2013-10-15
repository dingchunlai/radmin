module Pic
	require 'mini_magick'

	def self.case_img_resize(input)
		resize(input,"120x90","case")
		resize(input,"80x60","case")
	end
	
	#Mimi-magick
	def self.resize(input,size,name)
		output = get_output_path(input,size,name)
		image = MiniMagick::Image.from_file(input)
		image.resize size
		image.write output
	end

	def self.get_output_path(input,size,name)
		case name
	   	when "case"
	   		input[0..-5]+ "_" + size + input[-4..-1]
		end
	end
	
end