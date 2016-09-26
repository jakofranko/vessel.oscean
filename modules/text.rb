#!/bin/env ruby
# encoding: utf-8

class Page

	def body

		html = "<p>#{@term.bref}</p>#{@term.long}"
		
	    $lexicon.all.each do |name,term|
	    	if !term.unde.like(@term.name) then next end
	    	if term.name.like(@term.name) then next end
	    	html += term.template
	    end
	    return "<wr>#{html.markup}</wr>"

	end

end