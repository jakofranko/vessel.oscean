#: Shows various administration debug

require 'date'

class Page

  def body

    html = ""
    html += style

    html += "<pre>Available Diary: #{availableDiary}</pre>"

    return html

  end

  def availableDiary

    array = []
    @horaire.diaries.each do |log|
      array.push(log.photo)
    end
    array = array.sort

    i = 1
    while i < 999
      if array[i-1] != i then return i end
      i += 1
    end

    return i

  end

  def style

  	html = "
  	<style>
  		content.header,content.main { background:#000 }
      content.portal { display:none }
      content.title div.search { display: none }
      pre { background: #000; color:#fff}
  	</style>
  	"
  	return html

  end

end