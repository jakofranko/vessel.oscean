#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "<style>
    wr.horaire yu { display: inline-block;width: 340px;min-width: 300px;margin-bottom: 30px}
    wr.horaire yu ln { font-family: 'dinregular';font-size: 14px;line-height: 22px}
    wr.horaire yu ln .tp { font-family:'dinbold'}
    wr.horaire yu ln .tp:hover { text-decoration:underline}
    wr.horaire yu ln .tl { text-decoration:underline}
    wr.horaire yu ln .dt { color:#aaa}
    </style>"

  end

  def view

    html = "
    #{@term.long.runes.to_s}
    #{Graph.new(graphViewData)}
    #{recentEdits}
    #{latestUpdates}"

    return "<wr class='horaire'>#{html}</wr>"

  end

  def graphViewData

    a = []
    term.logs.each do |log|
      if log.elapsed < 0 then next end
      if log.elapsed/86400 > 100 then next end
      a.push(log)
    end
    return a

  end

  def recentEdits

    html = ""

    html_list = ""
    topicHistory = {}
    count = 0
    term.logs.each do |log|
      if log.topic == "" then next end
      if count >= 5 then break end
      if topicHistory[log.topic] then next end
      html_list += log.preview
      count += 1
      topicHistory[log.topic] = 1
    end
    return "<yu>#{html_list}</yu>"
    
  end

  def latestUpdates

    html = ""

    html_list = ""
    topicHistory = {}
    count = 0
    term.logs.each do |log|
      if log.task != "Update" then next end
      if count >= 5 then break end
      if topicHistory[log.topic] then next end
      html_list += log.preview
      count += 1
      topicHistory[log.topic] = 1
    end
    return "<yu>#{html_list}</yu>"
    
  end

end