#: Redirects to a random page of the wiki.

class Page

  def body

    html = ""

    html += "ello"

    require("/xxiivv/Jiin/core/jiin.rb")

    $jiin = Jiin.new
    lexicon = $jiin.command("disk load lexicon")

    html += lexicon["ABLETON"].to_s
    
    return html

  end

end