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
	    
	  return "External"

	end

	def template
		
		return "
		<a href='#{@url}' target='_blank'>
		<icon style='background-image:url(/img/interface/icon.#{domain.downcase}.png)'></icon>
		<span>#{name}<br />
		<small>#{domain.capitalize}</small></span>
		</a>"

	end

end