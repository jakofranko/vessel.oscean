# encoding: utf-8

class Page

	def body

		html = "#{@term.bref}#{@term.long}"
		
	    @lexicon.all.each do |name,term|
	    	if !term.unde.like(@term.name) then next end
	    	if term.name == @term.name then next end
	    	html += "
		    <content>
		      <h2><a href='/#{term.name}'>#{term.name}</a></h2>
		      <div class='full'>#{term.bref}</div>
		      #{term.long}
		    </content>"
	    end
	    return macros(html)

	end

end