require_relative "../objects/graph.rb"

class Layouts

  def horaire

    html = ""
    @graphData = graphData
    html += Graph.new(@graphData).draw
    html += CircleGraph.new(@graphData).draw
    html += "<hr />"
    return "<content class='wrap'>"+html+"</content>"

  end

  def module_horaire

    html = ""

    @graphData = graphData
    html += Graph.new(@graphData).draw
    html += CircleGraph.new(@graphData).draw
    html += "<hr />"
    return "<content class='wrap'>"+html+"</content>"

  end

  def graphData

    graphData = []
    $horaire.all.each do |date,log|
      if $page.topic != "Horaire" && log.topic != $page.topic then next end
      if log.sector == "misc" then next end
      graphData.push(log)
    end
    return graphData

  end

end