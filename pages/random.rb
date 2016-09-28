#!/bin/env ruby
# encoding: utf-8

class Oscea

  class Corpse

    def view

    	html = "<wr><p>Choosing a random page.</p></wr>
      <meta http-equiv='refresh' content='0; url=/#{$lexicon.to_h("term").sample.first}' />"

    	return html

    end
    
  end

end