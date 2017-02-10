#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Layout

  def style
    
     return "<style>
vi.forum { margin-bottom:30px; display:block;}
vi.forum thread { display: block;font-family:'input_mono_medium',monospace;font-size: 12px;line-height: 30px; color:#999; padding:0px 10px}
vi.forum thread.active { background:#72dec2; color:#fff}
vi.forum thread:hover { background:white; color:#000}
vi.forum thread b { font-family:'din_bold'; font-weight:normal}
vi.forum thread comment { display:block;}
vi.forum thread a { color:#000}
vi.forum thread a:hover { text-decoration:underline;}
vi.forum thread .activity { color:#000; font-family:'din_bold'}
vi.forum p.error { background:red; color:white; font-family:'din_bold'; font-size:14px; padding:0px 10px}
vi.forum p.success { background:#fff; color:000; font-family:'din_bold'; font-size:14px; padding:0px 10px}
vi.forum p.success a {color:000; font-family:'din_bold'; text-decoration:underline}
</style>"
     
  end
  
  def view
    
    html = "\n"
    html += "<p>Welcome to the {_:forums_}.</p>\n".markup
    html += "<p>This :forum page is the place to anonymously ask question, give feedback and report issues. New topics can be created by adding the suffix {_:forum_} to any existing term.</p>".markup
 
    if @module
      html += run_command(@module)+"\n"
    end
    
    html += "<div style='column-count:2'>#{main_list}</div>"
    
    return "<vi class='forum'>#{html}</vi>"

  end

  def main_list

    html = ""

    comments = Memory_Array.new("forum",@host.path)
    
    topics = {}
    comments.to_a("comment").reverse.each do |comment|
      if comment.topic.to_s.strip == "" then next end
      if !topics[comment.topic]
        topics[comment.topic] = {}
        topics[comment.topic]['threads'] = []
        topics[comment.topic]['replies'] = []
        topics[comment.topic]['active'] = comment.timestamp
      end
      if comment.nest
        topics[comment.topic]['replies'].push(comment)
      else
        topics[comment.topic]['threads'].push(comment)
      end
    end
    
    topics.each do |topic,content|
      html += "
      <thread class='#{content['active'].elapsed < 10000 ? "active" : ""}'>
        <span class='activity'>#{content['replies'].length.to_s.prepend('0',2)}#{content['threads'].length.to_s.prepend('0',2)}</span>
        #{@lexicon.filter("term",topic,"term").unde}/<a href='/#{topic}:forum'>#{topic}</a>   
        <span class='timestamp'>#{content['active'].ago}</span>\n
      </thread>"
    end
  
    return html

  end
  
  def run_command cmd
    
    topic   = nil
    reply   = nil
    message = cmd.gsub('+',' ')
    
    if message.split(" ").first[0,6] == "topic-"
      topic = message.split(" ")[0].split("-").last
      message = message.sub("topic-#{topic}","").strip
    end

    if message.split(" ").length > 0 && message.split(" ").first[0,6] == "reply-"
      reply = message.split(" ")[0].split("-").last.to_i
      message = message.sub("reply-#{reply}","").strip
    end
    
    comments = Memory_Array.new("forum",@host.path)

    # Check if topic exists
    if topic.to_s == "" || message.to_s == "" then return "<p class='error'>Something went wrong with the topic attached.</p>" end
    
    message = message.gsub(',,','.')

    # Check for badwords
    bad_dict = ["dick","pussy","asshole","nigger"]
    bad_dict.each do |word|
      if message.include? word then return "<p class='error'>You cannot use the word <i>#{word}</i> on the forum.</p>" end
    end
    
    # Check if message already exists
    comments.to_a("comment").each do |comment|
      if !comment.message then next end
      if !comment.topic.to_s.like(topic) then next end
      if comment.message.to_s.downcase.gsub(/[^a-z0-9\s]/i, '').like(message.downcase.gsub(/[^a-z0-9\s]/i, '')) then return "<p class='error'>Your comment is a duplicate.</p>" end
    end
    
    message = message.strip
    message = message.gsub(/[^A-Za-z0-9\,\!\.\s\{\}\*\_\-\~]/i, '')

    # Save
    comments.append("#{Timestamp.new.to_s.append(' ',14)} #{topic.to_s.capitalize.append(' ',20)} #{reply.to_s.append(' ',4)} #{message}")
    
    return "<p class='success'>Your comment on <a href='/#{topic}:forum'>#{topic}</a> has been saved.</p>"
    
  end
  
end
