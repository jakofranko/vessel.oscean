#: Missing..

require_relative "../objects/graph.rb"

class Page

  def body

    html = ""
    html += "<p>This graph shows the latest activity on <a href='/#{@term.topic}'>#{@term.topic}</a>.</p>"
    @graphData = graphData
    if @graphData.length > 0 
      html += Graph.new(@graphData).draw
      html += "<hr />"
    else 
      html += "<p>Missing data.</p>"
    end
    return "<content class='wrap'>#{macros(html)}</content>"

  end

  def graphData

    graphData = []
    @horaire.all.each do |date,log|
      if @term.topic != "Horaire" && log.topic != @term.topic then next end
      if log.sector == "misc" then next end
      graphData.push(log)
    end
    return graphData

  end

end