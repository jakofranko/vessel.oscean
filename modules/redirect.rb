#!/bin/env ruby
# encoding: utf-8

class Oscean

  class Corpse

    def view

      if !term.type_value then return "<wr><p>Redirection error, sorry.</p></wr>" end
      
      target = term.type_value.like("random") ? lexicon.to_h("term").to_a.sample.first.downcase : term.type_value

    	html = "<wr><p>Redirecting..</p></wr>
      <meta http-equiv='refresh' content='0; url=/#{target.gsub(' ','+')}' />"

    	return html

    end
    
  end

end