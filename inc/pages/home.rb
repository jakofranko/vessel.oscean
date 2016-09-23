# encoding: utf-8

class Page

  def body

    html = "<p>#{@term.bref}</p>#{@term.long}"

    html += thisMonth
    html += recentEdits
    html += latestUpdates
    html += "<hr/>"

  	return "<wr>"+macros(html)+"</wr>"

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
    <p>This graph shows the time invested in audio, visual and research projects for the past 3 months. You can see the time logged into projects of the past 10 years by visiting the <a href='/Horaire'>Horaire</a> module.</p>
    <p style='background:white; padding:15px; font-size:14px; border-radius:3px'>Currently sailing across the Ocean, as of <i>July 4th 2016</i>, and will be unable to consistently update the playground. You can learn more about the adventure on the <a href='http://100r.co'>Hundred Rabbits Site</a>.</p>"

  end

  def recentEdits

    html = ""

    html_list = ""
    topicHistory = {}
    count = 0
    @horaire.all.each do |date,log|
      if log.topic == "" then next end
      if count >= 5 then break end
      if topicHistory[log.topic] then next end
      html_list += log.preview
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
      html_list += log.preview
      count += 1
      topicHistory[log.topic] = 1
    end
    
    html += html_list

    return "<content style='margin-bottom:30px' class='half'>"+html+"</content>"
    
  end

end