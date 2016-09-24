# encoding: utf-8

class Link

	def initialize(name,url)

    	@name = name
    	@url = url.to_s

	end

	def name

		case @name
		when "GITH"
			return "Source Files"
		when "ITUN"
			return "iTunes Store"
		when "TWTR"
			return "Twitter"
		when "PATR"
			return "Patreon"
		when "BAND"
			return "Bandcamp"
		when "DRIV"
			return "Download File"
		else
			return @name
		end
			
	end

	def domain

	  if @url.include? "beldamrecords.bandcamp" then return "BeldamRecords" end
	  if @url.include? "github" then return "Github" end
	  if @url.include? "itunes" then return "iTunes" end
	  if @url.include? "xxiivv" then return "Oscean" end
	  if @url.include? "bandcamp" then return "Bandcamp" end
	  if @url.include? "noirmirroir" then return "Noirmirroir" end
	  if @url.include? "twitter" then return "Twitter" end
	  if @url.include? "patreon" then return "Patreon" end
	  if @url.include? "youtu" then return "Youtube" end
	  if @url.include? "drive.google" then return "Google Drive" end
	    
	  return "External"

	end

	def template
		
		return "<a href='#{@url}' target='_blank' class='lk'>#{Media.new("interface","icon."+domain).to_html}<b>#{name}</b><i>#{domain.capitalize}</i></a>"

	end

end