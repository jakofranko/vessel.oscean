#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
<style>
  .activity { column-count:3; }
  .activity .date { float:right; font-size:12px; color:#555 }
</style>"

  end

  def view

    html = !@term.bref ? "" : "<p>"+@term.bref+"</p>"+@term.long.runes+"\n"

    html += recent

    html += "<p>If you wish to stay updated on the development of the latest projects, follow {{@Neauoire|http://twitter.com/neauoire}}. </p>".markup

    return html

  end

  def recent

    html = ""

    count = 0
    @term.logs.each do |log|
      if count == 10 then break end
      html += log.preview
      count += 1
    end

    return "<h2>Recent Activity</h2><list class='activity'>#{html}</list>"

  end

end