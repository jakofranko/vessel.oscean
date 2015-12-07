=begin
<p>TODO:</p>
=end
require_relative "../objects/graph.rb"

class Layouts

  def home

    html = $page.definition
    html += "<p>If this is your first time around, the {{Introduction}} is a good place to begin your exploration. If you wish to stay updated on the development of the latest projects, follow {{@Neauoire|http://twitter.com/neauoire}}. </p>"

    html += recentEdits
    html += latestUpdates
    html += "<hr/>"
    html += activeIssues
    html += thisMonth

  	return html

  end

  def graphViewData

    graphData = []
    $horaire.all.each do |date,log|
      if log.elapsed < 0 then next end
      if log.elapsed/86400 > 100 then next end
      graphData.push(log)
    end
    return graphData

  end

  def thisMonth

    html = "<h2>#{Desamber.new().default_month_year}</h2>"
    html += Graph.new(graphViewData).draw
    return html

  end

  def recentEdits

    html = "<h2>Recent Edits</h2>"

    html_list = ""
    topicHistory = {}
    count = 0
    $horaire.all.each do |date,log|
      # if log.task == "Update" then next end
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

    html = "<h2>Latest Updates</h2>"

    html_list = ""
    topicHistory = {}
    count = 0
    $horaire.all.each do |date,log|
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

  def activeIssues

    html = "<h2>Active Issues</h2>"

    topicHistory = {}
    count = 0
    $issues.reverse.each do |issue|
      if !issue.active then next end
      if count >= 5 then break end
      if topicHistory[issue.topic] then next end
      html += issue.template
      count += 1
      topicHistory[issue.topic] = 1
    end
    
    return "<content style='margin-bottom:30px'>"+html+"</content>"

  end

end