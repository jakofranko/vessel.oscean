# encoding: utf-8

class Media

	def initialize(cat,id,url = nil)

    	@id  = id.to_s.downcase.gsub(" ",".")
    	@cat = cat.to_s.downcase.gsub(" ",".")

	end

	def to_html

		if File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.mp4")
      return "<video class='media' autoplay loop><source src='/media/#{@cat}/#{@id}.mp4' type='video/mp4'>Your browser does not support the video tag.</video>"
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.jpg")
      return "<media style='background-image:url(/media/#{@cat}/#{@id}.jpg)'></media>" 
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.png")
      return "<media style='background-image:url(/media/#{@cat}/#{@id}.png)'></media>" 
    end
    return "[missing:#{@id}-#{@cat}]"

	end

end