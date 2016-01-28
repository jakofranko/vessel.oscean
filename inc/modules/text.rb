#: Missing..

class Page

	def body

		html = macros(@term.definition)
	    children = Oscean.new(@term.topic).lexiconFind("parent",@term.topic)
	    children.each do |term|
	    	if term.topic == @term.topic then next end
	    	html += "
		    <content>
		      <h2><a href='/#{term.topic}'>#{term.topic}</a></h2>
		      <div class='full'>#{term.definition}</div>
		    </content>"
	    end
	    return macros(html)

	end

end