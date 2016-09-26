# encoding: utf-8

class Media

	def initialize(cat,id,url = nil)

    	@id  = id.to_s.downcase.gsub(" ",".")
    	@cat = cat.to_s.downcase.gsub(" ",".")
      @class = nil

	end

  def exists

    if File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.jpg")
      return "jpg"
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.png")
      return "png"
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.mp4")
      return "mp4"
    end
    return nil

  end

  def set_class c

    @class = c

  end

	def to_html

		if File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.mp4")
      return "<video #{@class ? "class='#{@class}'" : ""} autoplay loop><source src='/media/#{@cat}/#{@id}.mp4' type='video/mp4'>Your browser does not support the video tag.</video>"
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.jpg")
      return "<media #{@class ? "class='#{@class}'" : ""}  style='background-image:url(/media/#{@cat}/#{@id}.jpg)'></media>" 
    elsif File.exist?("/var/www/client.oscean/media/#{@cat}/#{@id}.png")
      return "<media #{@class ? "class='#{@class}'" : ""} style='background-image:url(/media/#{@cat}/#{@id}.png)'></media>" 
    end
    return "[missing:#{@id}:#{@cat}:#{@class}]"

	end

end