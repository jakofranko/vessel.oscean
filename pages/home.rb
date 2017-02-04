#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
<style>
  .activity { }
  .activity .entry { width:33%; min-width:200px; display:inline-block; height:25px;overflow: hidden}
  .activity .value { color:#555; margin-left:10px; font-size:14px }
  .activity .progress { max-width:50px; width:20%; background:#fff; height:5px; float:right; border-radius:3px; overflow:hidden; margin-top:10px; margin-right:15px}
  .activity .progress .bar { height:5px; background:#000}
</style>"

  end

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    html += recent

    html += "<p>If you wish to stay updated on the development of the latest projects, follow {{@Neauoire|http://twitter.com/neauoire}}. </p>".markup

    return html

  end

  def recent

    html = ""

    @topics = {}

    count = 0
    @term.logs.each do |log|
      if count == 60 then break end
      if log.topic.to_s == "" then next end
      @topics[log.topic] = @topics[log.topic].to_i + log.value
      count += 1
    end

    h = @topics.sort_by {|_key, value| value}.reverse
    max = h.first.last.to_f

    h.each do |name,val|
      html += "<div class='entry'><a href='/#{name}'>#{name}</a><span class='value'>#{val}h</span><div class='progress'><div class='bar' style='width:#{(val/max)*100}%'></div></div><hr/></div>"
    end

    return "<h2>Recent Activity</h2><list class='activity'>#{html}</list>"

  end

end