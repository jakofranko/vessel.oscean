#: Missing..

class Page

	def body

		html = @term.definition
	    children = Oscean.new(@term.topic).lexiconFind("parent",@term.topic)
	    children.each do |term|
	    	diary = @horaire.featuredDiaryWithTopic(term.topic)
	    	html += "
		    <content class='diary'>
		      <a href='/#{term.topic}'>#{Image.new(diary.photo).view}</a>
		      <small>#{diary.offset}</small>
		      <h1>#{term.topic}</h1>
		      <div class='full'>#{term.description}</div>
		    </content>"
	    end
	    return macros(html)

	end

end