# encoding: utf-8

class Media

	def initialize(cat,id,url = nil)

    	@id  = id
    	@cat = cat

	end

	def to_html

		if @id.to_i < 1 then return "" end

		if File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.mp4")
      return "<video class='media' autoplay loop><source src='/media/#{@cat}/#{@id}.mp4' type='video/mp4'>Your browser does not support the video tag.</video>"
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.jpg")
      return "<content class='media' style='background-image:url(/media/#{@cat}/#{@id}.jpg)'></content>"
    end
    return ""

	end

end