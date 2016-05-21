require_relative "../objects/graph.rb"

class Page

  def body

    html = "#{@term.bref}#{@term.long}"

    html += thisMonth
    html += recentEdits
    html += latestUpdates
    html += "<hr/>"

  	return macros(html)

  end

  def graphViewData

    graphData = []
    @horaire.all.each do |date,log|
      if log.elapsed < 0 then next end
      if log.elapsed/86400 > 100 then next end
      graphData.push(log)
    end
    return graphData

  end

  def thisMonth

    return Graph.new(graphViewData).draw+"
    <p>This graph shows the time invested in audio, visual and research projects for the past 3 months. You can see the time logged into projects of the past 10 years by visiting the <a href='/Horaire'>Horaire</a> module.</p>"

  end

  def recentEdits

    html = ""

    html_list = ""
    topicHistory = {}
    count = 0
    @horaire.all.each do |date,log|
      if log.topic == "" then next end
      if log.title != "" then next end
      if count >= 5 then break end
      if topicHistory[log.topic] then next end
      html_list += log.template
      count += 1
      topicHistory[log.topic] = 1
    end

    html += html_list

    return "<content style='margin-bottom:30px' class='half'>"+html+"</content>"
    
  end

  def latestUpdates

    html = ""

    html_list = ""
    topicHistory = {}
    count = 0
    @horaire.all.each do |date,log|
      if log.task != "Update" then next end
      if count >= 5 then break end
      if topicHistory[log.topic] then next end
      html_list += log.template
      count += 1
      topicHistory[log.topic] = 1
    end
    
    html += html_list

    return "<content style='margin-bottom:30px' class='half'>"+html+"</content>"
    
  end

end