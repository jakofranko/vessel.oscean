#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
<style>
  .activity { background:black; color:white; margin-top:-30px; padding:30px }
  .activity > ln { width:33%; min-width:200px; display:inline-block; height:30px;overflow: hidden; font-size: 14px !important;}
  .activity .value { color:#555; margin-left:10px; font-size:14px }
  #notice { font-family:'din_regular'; font-size:16px; line-height:26px; background:#fff; padding:15px 20px; border-radius:3px}
  #notice a { font-family: 'din_medium'}
</style>"

  end

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"
    html += event
    html += recent
    
    return html

  end

  def event

    return "<p id='notice'>I am currently in {{$ hundredrabbits get_location}}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to reply to the {{forum}} as frequently, or answer emails. I will get back to you upon landfall. You can track our sail {{here|http://100r.co/#map}}.</p>".markup

  end

  def recent

    html = ""

    @topics = {}

    count = 0
    @term.logs.each do |log|
      if count == 60 then break end
      if log.topic.to_s == "" then next end
      if !@topics[log.topic] then @topics[log.topic] = {} ; @topics[log.topic][:sum] = 0 end  
      if !@topics[log.topic][log.sector] then @topics[log.topic][log.sector] = 0 end
      @topics[log.topic][log.sector] += log.value
      @topics[log.topic][:sum] += log.value
      count += 1
    end

    h = @topics.sort_by {|_key, value| value[:sum]}.reverse
    max = h.first.last[:sum]

    h.each do |name,val|
      values = {:audio => val[:audio], :visual => val[:visual], :research => val[:research]}
      html += "<ln><a href='/#{name}'>#{name}</a><span class='value'>#{val[:sum]}h</span>#{Progress.new(values,max)}<hr/></ln>"
    end

    return "#{Graph_Timeline.new(term,0,100)}<list class='activity'>#{html}</list>"

  end

end