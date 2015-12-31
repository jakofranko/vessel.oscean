#: Missing

class Page

  def body

  	html = macros(@term.definition)
    
    lastLetter = "4"
    html += "<ul>"
    @lexicon.all.each do |topic,term|
      if term.topic[0,1].downcase != lastLetter.downcase
        lastLetter = term.topic[0,1]
        html += "<li style='font-size:30px; line-height:40px'>#{lastLetter}</li>"
      end
      html += "<li style='font-size:14px'><a href='/#{term.topic}'>#{term.topic}</a></li>"
    end
    html += "</ul>"
  	return html

  end

end