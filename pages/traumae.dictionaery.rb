class Layouts

  def dictionaery

    $dictionaery = $oscean.dictionaery()

  	html = ""

    html += $page.definition

    html += generateList()

  	return html

  end

  def generateList

    html = ""
    html += "<ul class='column'>"

    $dictionaery.all.each do |laeth|
      html += "<li><b>"+laeth.traumae+"</b>, "+laeth.adultspeak+" - "+laeth.english+"</li>"
    end

    html += "</ul>"

    return html

  end

end