#: <p>Shows a list of all children topics with images.</p>

class Layouts

  def index

    html = $page.definition
    children = Oscean.new($page.topic).lexiconFind("parent",$page.topic)
    children.each do |term|
      html += ( term.featured ) ? Image.new(term.featured.photo).view : ""
      html += "<h2>{{#{term.topic}}}</h2>"
      html += term.definition.firstParagraph
      html += "<ul>"
      term.children.each do |term|
        html += "<li>{{#{term.topic}}}</li>"
      end
      html += "</ul>"
      html += term.template_links
    end

    return html

  end

end 