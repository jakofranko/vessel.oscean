#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Module
  
  def style
    
     return "<style>
form { background: #ddd; border-radius: 4px; margin-bottom:30px }
form textarea {display: block; width: calc(100% - 20px); padding: 10px; border-radius: 3px;}
form pre { font-family: monospace;font-size: 12px;padding: 10px;color: #555;}
thread { display: block;padding: 10px;font-family: monospace;font-size: 14px;line-height: 20px; border-top:1px solid #ccc}
thread comment { display:block;}
thread comment.nested { margin-left:30px}
thread comment.nested:before { content:'>'; margin-right:10px; color:#999 }
thread comment .timestamp { color: #999; }
thread a.reply { background: white;color: #999;padding: 2px 5px;border-radius: 3px;line-height: 25px;}
</style>"
     
  end

  def script
  
    return '<script>
$(document).on("keydown", "#commander", function(e)
{
  if ((e.keyCode == 10 || e.keyCode == 13) && e.ctrlKey){
    var command = document.getElementById("commander").value;
    console.log(command);
    document.location = "http://wiki.xxiivv.com/Forum:topic-'+@term.name+' "+command;
  };
});

$(".reply").on("click", function(e) {
  document.getElementById("commander").value = "reply-"+$(this).attr("data")+" ";
  document.getElementById("commander").focus();
});
</script>'
  end
  
  def view
    
    html = "\n"
    html += "<p>This {_:forum_} page is the place to anonymously ask question, give feedback and report issues about {{#{@term.name}}}.</p>\n".markup
    html += "<form><textarea id='commander' placeholder='Input comment here'></textarea><pre>{  } Link {**} Bold {__} Italic ~Username <span style='float:right'>CTRL+ENTER to post</span></pre></form>\n\n"
    comments = Memory_Array.new("forum",@host.path).filter("topic",@term.name,"comment")
    
    id = 1
    comments.each do |comment|
      comment.id = id
      # Main comments
      if comment.nest then next end
      html += "<thread>"
      html += comment.to_s
      # Nested comments
      comments.each do |comment|
        if comment.nest != id then next end
        html += comment.to_s
      end
      html += "<a data='#{id}' class='reply'>+ reply</a>"
      html += "</thread>"
      id += 1
    end

    # Send to: forum:say-verreciel reply-0 this is a new nested comment, sometimes.
    
    return "<wr>#{html}</wr>"+script

  end
  
end
