#: Redirects to a random page of the wiki.

class Page

  def body

    html = ""

    html += "ello"

    horaire = $jiin.command("disk load horaire")

    horaire.each do |k,v|
    	html += "#{k}(#{v})<br />"
    end
    
    return html

  en