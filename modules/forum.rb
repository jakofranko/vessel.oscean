#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Module
  
  def style
    
     return "<style>
vi.forum form { background: #000; color:white; margin-bottom:30px }
vi.forum form textarea {display: block; width: calc(100% - 20px); padding: 10px; color:#000;font-family: 'input_mono_medium',monospace;font-size: 12px;}
vi.forum form pre { font-family: 'input_mono_medium',monospace;font-size: 12px;padding: 10px;color: #fff;}
vi.forum thread { display: block;font-family: 'input_mono_medium',monospace;font-size: 12px;line-height: 20px;margin-bottom: 30px;border-bottom: 1px solid #ccc;padding-bottom: 30px }
vi.forum thread comment { display:block; }
vi.forum thread comment.nested .message { padding-left:30px;display: block; background:none}
vi.forum thread comment.nested .message:before { content:'>'; margin-right:10px; color:#999 }
vi.forum thread comment .key { float:left}
vi.forum thread comment .timestamp { color: #999; }
vi.forum thread comment .timestamp:hover { text-decoration:underline; cursor:pointer}
vi.forum thread comment .author { font-family:'input_mono_regular'; padding:10px 0px; display:inline-block}
vi.forum thread comment .message { margin-left:200px;display: block; background:white; padding:10px}
vi.forum thread comment .message a { text-decoration:underline}
vi.forum thread comment .message b { font-family:'input_mono_regular'; font-weight:normal}
vi.forum thread comment .author.admin:after { content:'*'; color:#72dec2}
</style>"
     
  end

  def script
  
    return '<script>
$(document).on("keydown", "#commander", function(e)
{
  if ((e.keyCode == 10 || e.keyCode == 13) && e.ctrlKey){
    var command = document.getElementById("commander").value;
    document.location = "/Forum:topic-'+@term.name+' "+(command);
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
    html += "<p>Anonymously ask questions, give feedback and report issues about {{#{@term.name}}}.</p>\n".markup
    html += "<form><textarea id='commander' placeholder='Input comment here'></textarea><pre>{*<b>bold</b>*} {_<i>italic</i>_} ~Username <span style='float:right'>CTRL+ENTER to post</span></pre></form>\n\n"
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
      html += "</thread>"
      id += 1
    end

    return "<vi class='forum'>"+html+script+"<p>Return to the <a href='/Forum'>forum index</a>.</p></vi>"

  end
  
end
