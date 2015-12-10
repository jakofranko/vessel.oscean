=begin
<p>Redirects to a random page of the wiki.</p>
=end

class Layouts

  def random

  	html = ""
    
    termsArray = $lexicon.all.to_a

    randomNumber = rand(termsArray.length)
    randomTerm = termsArray[randomNumber]

    html += '<meta http-equiv="refresh" content="0; url='+randomTerm[0].to_s+'" />'

  	return html

  end

end