#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Module
  
  def style
    
     return "<style>
form { background: #ddd; border-radius: 4px; margin-bottom:30px }
form textarea {display: block; width: calc(100% - 20px); padding: 10px; border-radius: 3px;}
form pre { font-family: monospace;font-size: 12px;padding: 10px;color: #555;}
thread { background: black; display: block;color: white;padding: 10px;font-family: monospace;font-size: 14px;line-height: 20px;}
thread comment { display:block;}
thread comment.nested { margin-left:30px}
</style>"
     
  end
  
  def view
    
    html = "\n"
    html += "<p>This {_:forum_} page is the place to anonymously ask question, give feedback and report issues about {{#{@term.name}}}. Visit the {{/forum|Forum}} page for a list of all the topics.</p>\n".markup
    html += "<form><textarea placeholder='Input comment here'></textarea><pre>{  } Link {**} Bold {__} Italic</pre></form>\n\n"
    comments = Memory_Array.new("forum",@host.path).filter("topic",@term.name,"comment")
    
    html += "<thread>"
    id = 1
    comments.each do |comment|
      comment.id = id
      # Main comments
      if comment.nest then next end
      html += comment.to_s
      # Nested comments
      comments.each do |comment|
        if comment.nest != id then next end
        html += comment.to_s
      end
      id += 1
    end
    html += "</thread>"    

    # Send to: forum:say-verreciel reply-0 this is a new nested comment, sometimes.
    
    return "<wr>#{html}</wr>"

  end
  
end
