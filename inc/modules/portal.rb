#: Missing..

class Page

	def body

		html = macros(@term.definition)
	    children = Oscean.new(@term.topic).lexiconFind("parent",@term.topic)
	    children.each do |term|
	    	diary = @horaire.featuredDiaryWithTopic(term.topic)
	    	html += "
		    <content class='diary'>
		      <a href='/#{term.topic}'>#{diary != nil ? Image.new(diary.photo).view : ""}</a>
		      <small>#{diary != nil ? diary.offset : "unknown"}</small>
		      <h1>#{term.topic}</h1>
		      <div class='full'>#{term.description}</div>
		    </content>"
	    end
	    return macros(html)

	end

end