#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessel.corpse

def corpse.view

  if !@term.type_value then return "<wr><p>Redirection error, sorry.</p></wr>" end
  
  target = @term.type_value.to_s.like("random") ? @lexicon.to_h("term").to_a.sample.first.downcase : @term.type_value

  html = "<wr><p>Redirecting..</p></wr><meta http-equiv='refresh' content='0; url=/#{target.to_s.gsub(' ','+')}' />"

  return html

end