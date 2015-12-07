class Layouts

  def text

    lexicon = $oscean.lexiconFind("parent",$page.topic)

    html = ""

    html += $page.definition

    lexicon.each do |term|
      if term.topic == $page.topic then next end
    	html += "<h2 id='"+term.topic+"'>{{"+term.topic+"}}</h2>"
    	html += term.definition
      html += term.template_links
    end

  	return "<content class='lexicon'><wrapper>"+html+"</wrapper></content>"

  end



end