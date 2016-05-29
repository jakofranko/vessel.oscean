# encoding: utf-8

class Page

	def body

		html = "#{@term.bref}#{@term.long}"
		
	    @lexicon.all.each do |name,term|
	    	if !term.unde.like(@term.name) then next end
	    	photo = photoForTerm(term.name)
	    	html += "<content>
		      #{photo != nil ? "<a href='"+name.downcase+"'>"+Image.new(photo).view+"</a>" : ""}
		      <div class='full'>#{term.bref}</div>
		    </content>"
	    end

	    return macros(html)

	end

	def photoForTerm term

		@horaire.all.each do |date,log|
			if log.topic != term then next end
			if log.photo < 1 then next end
			return log.photo
		end


	end

	
end