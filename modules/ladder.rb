#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{term.bref}</p>#{term.long.runes}"

    ladder = Memory_Hash.new(term.name,path)

    html += "<table>"
    ladder.to_h.each do |cat,con|
      html += "<tr><th>#{cat}</th></tr>\n"
      con.sort.each do |term,con|
        con = con.to_a
        html += "<tr><td><b>#{term}</b></td><td>#{con.first.last}</td></tr>\n"
      end
    end
    html += "</table>"

    return "<wr>#{html}</wr>"

  end

end
