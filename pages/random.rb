#!/bin/env ruby
# encoding: utf-8

class Page

  def body

  	html = "<wr><p>Choosing a random page.</p></wr>
    <meta http-equiv='refresh' content='0; url=/#{$lexicon.all.sample.first}' />"

  	return html

  end

end