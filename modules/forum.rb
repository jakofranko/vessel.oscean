#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Module
  
  def style
    
     return "<style></style>"
     
  end
  
  def view
    
    html = "\n"
    html += "<p>This {_:talk_} page is the place to anonymously ask question, give feedback and report issues about {{Oquonie}}. Visit the {{/talk}} page for a list of all the topics.</p>\n"
    html += "<form><textarea placeholder='Input comment here'></textarea></form>\n<pre>Markup: {  } Link {**} Bold {__} Italic</pre>\n"
    comments = Memory_Array.new("forum",@host.path).filter("term",@term,"comment")
    
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
    
    # Send to: forum:say-verreciel reply-0 this is a new nested comment, sometimes.
    
    return "<wr>#{html}</wr>"

  end
  
end