#: Redirects to a random page of the wiki.

class Page

  def body

  	html = "<p>Choosing a random page.</p>"
    
    destination = @lexicon.all.sample

    html += "<meta http-equiv='refresh' content='0; url=/#{destination.first}' />"

  	return html

  end

end