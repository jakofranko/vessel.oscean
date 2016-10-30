#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = ""
    ladder = Memory_Hash.new(term.name,@host.path)

    ladder.to_h.each do |cat,con|
      html += "<h2>#{cat.capitalize}</h2>\n"
      if con.kind_of?(Hash)
        con.each do |k,v|
          html += "<h4>#{k}</h4>\n<p>#{v.first}</p>\n"
        end
      elsif con.kind_of?(Array)
        html += con.runes
      else
        html += con
      end
    end

    return "<wr>#{html}</wr>".markup

  end

end
