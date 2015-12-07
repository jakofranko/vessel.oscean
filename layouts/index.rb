=begin
<p>Shows a list of all children topics with images.</p>
=end
class Layouts

  def index

    html = ""

    html += $page.definition

    children = Oscean.new($page.topic).lexiconFind("parent",$page.topic)

    children.each do |term|
      if File.exist?("img/diary/#{term.photo}.jpg")
        html += "<a href='"+term.topic+"'><img src='/img/diary/#{term.photo}.jpg' style='width:100%; margin-bottom:30px'></a>"
      end
      html += "<h2>{{"+term.topic+"}}</h2>"
      html += firstParagraph(term.definition)
      html += term.template_links
    end

    return html

  end

end 