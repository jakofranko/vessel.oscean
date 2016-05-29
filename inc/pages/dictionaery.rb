# encoding: utf-8

class Page

  def body

  	html = macros(@term.definition)
    
    lastLetter = "4"
    html += "<ul>"
    $oscean.dictionaery.sort.each do |index,aeth|
      if index[0,1].downcase != lastLetter.downcase
        lastLetter = index[0,1]
        html += "<li style='font-size:30px; line-height:40px'>#{lastLetter.capitalize}</li>"
      end
      html += "<li style='font-size:14px'><b>#{aeth.adultspeak}</b> <i>#{index}</i>, #{aeth.english}"

      html += "</li>"
    end
    html += "</ul>"
  	return html

  end

end