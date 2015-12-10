=begin
<p>An alphabetically sorted lexicon of every term found on XXIIVV.</p>
=end

class Layouts

  def dictionary

  	html = $lexicon.term("Dictionary").definition
    
    lastLetter = "4"

    html += "<ul class='column'>"
    $lexicon.all.each do |topic,term|
      if term.topic[0,1].downcase != lastLetter.downcase
        lastLetter = term.topic[0,1]
        html += "<li style='font-size:30px; line-height:40px'>#{lastLetter}</li>"
      end
      html += "<li style='font-size:14px'>{{#{term.topic}}}</li>"
    end
    html += "</ul>"

  	return html

  end

end