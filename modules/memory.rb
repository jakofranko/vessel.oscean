#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = @term.long.runes
    ladder = Memory_Hash.new(term.name,@host.path)

    ladder.to_h.each do |cat,con|
      html += "<h2>#{cat}</h2>\n"
      if con.kind_of?(Array)
        con.each do |text|
          html += "<p>#{text}</p>"
        end
      else
        html += "<list>"
        con.each do |k,v|
          html += "<line><b>#{k}</b>: #{v.to_a.last.last}</line>\n"
        end
        html += "</list>"
      end
    end

    return "<wr>#{html}</wr>"

  end

end
