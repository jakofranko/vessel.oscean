# encoding: utf-8
#: The {{Link}} object wraps around {{URL}} constructs.

class Link

	def initialize(data)
    	@data = data
	end

	def name
		if domain == "bandcamp" then return "Listen to Album" end
		if domain == "itunes" then return "Download on iTunes" end
		if domain == "github" then return "View Source Files" end
		if domain == "patreon" then return "Support on Patreon" end
		return @data.split("|")[0].to_s.downcase.capitalize
	end

	def url
		return @data.split("|")[1].to_s.downcase.capitalize
	end

	def domain
		return makeDomain(url).downcase
	end

	def type
		if name[0,1] == "\"" then return "quote" end
		return "external"
	end

	def source
		return url.split("//")[1].split(".")[0]
	end

	def makeDomain url

	  if url.include? "beldamrecords.bandcamp" then return "BeldamRecords" end
	  if url.include? "github" then return "Github" end
	  if url.include? "itunes" then return "iTunes" end
	  if url.include? "xxiivv" then return "Oscean" end
	  if url.include? "bandcamp" then return "Bandcamp" end
	  if url.include? "noirmirroir" then return "Noirmirroir" end
	  if url.include? "twitter" then return "Twitter" end
	  if url.include? "patreon" then return "Patreon" end
	    
	  return "External"

	end

	def template
		if type == "quote"
	      	linkName = name.gsub("\"","").capitalize
			return "
			<a href='#{url}'>
				<span>#{linkName}</span>
				<small>#{url}</small>
			</a>"
		else
			return "
			<a href='"+url+"' target='_blank'>
			<icon style='background-image:url(/img/interface/icon."+domain+".png)'></icon>
			<span>"+name+"<br />
			<small>"+domain.capitalize+"</small></span>
			</a>"
		end
	end

end