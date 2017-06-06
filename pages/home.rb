#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
<style>
  .activity { background:black; color:white; margin-top:-30px; padding:30px; vertical-align:top; border-bottom:1px solid #efefef }
  .activity > ln { min-width:200px; display:inline-block; height:30px;overflow: hidden; font-size: 14px !important; vertical-align:top}
  .activity .value { color:#555; margin-left:10px; font-size:14px }
  #notice { font-family:'din_regular'; font-size:16px; line-height:26px; background:#fff; padding:15px 20px; border-radius:3px}
  #notice a { font-family: 'din_medium'}
  ul.legend { font-size: 12px;padding: 15px 0px 0px 0px;}
  ul.legend li { font-family:'din_regular'; color:grey; line-height:15px}
  ul.legend li b { font-weight:normal; font-family:'din_medium'}
</style>"

  end

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"
    html += "<p id='notice'>I am currently in {{$ hundredrabbits get_location}}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to reply to the {{forum}} as frequently, or answer emails. I will get back to you upon landfall. You can track our sail {{here|http://100r.co/#map}}.</p>".markup
    html += Graph_Timeline.new(term,0,100).to_s
    html += Graph_Topics.new(term,0,100).to_s
    html += Graph_Tasks.new(term,0,100).to_s
    
    return html

  end

end