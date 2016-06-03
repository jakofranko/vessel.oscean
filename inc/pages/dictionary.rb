# encoding: utf-8

class Page

  def body

  	html = macros(@term.bref)
    
    lastLetter = "4"
    html += "<ul style='column-count:3'>"
    @lexicon.all.each do |topic,term|
      if term.name[0,1].downcase != lastLetter.downcase
        lastLetter = term.name[0,1]
        html += "<h2 style='font-size: 30px;line-height: 50px;margin: 0px;'>#{lastLetter}</h2>"
      end
      html += "<li style='font-size:16px'><a href='/#{term.name}'>#{term.name}</a></li>"
    end
    html += "</ul>"
  	return html

  end

end