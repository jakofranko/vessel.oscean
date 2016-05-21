#: Missing..

class Page

	def body

		html = "#{@term.bref}#{@term.long}"
		
	    @lexicon.all.each do |name,term|
	    	if !term.unde.like(@term.name) then next end

	    	html += "<content class='diary'>
		      <a href='/#{term.name}'>#{diary != nil ? Image.new(diary.photo).view : ""}</a>
		      <small>#{diary != nil ? diary.offset : ""}</small>
		      <h1><a href='/#{term.name}'>#{term.name}</a></h1>
		      <div class='full'>#{term.bref}</div>
		    </content>"
	    end

	    return macros(html)

	end

	
end