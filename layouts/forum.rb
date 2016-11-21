#!/bin/env ruby
# encoding: utf-8

class CorpseHttp # Layout

  def style
    
     return "<style></style>"
     
  end
  
  def view
    
    html = "\n"
    html += "<p>The <b>Forum</b> is a list of active topics.</p>\n"
    
    if @module
      html += run_command(@module)+"\n"
    end
    
    # List topics
    
    comments = Memory_Array.new("forum",@host.path)
    
    topics = {}
    comments.to_a("comment").reverse.each do |comment|
      if !topics[comment.topic]
        topics[comment.topic] = {}
        topics[comment.topic]['threads'] = 0
        topics[comment.topic]['replies'] = 0
        topics[comment.topic]['active'] = comment.timestamp
      end
      if comment.nest
        topics[comment.topic]['replies'] += 1
      else
        topics[comment.topic]['threads'] += 1
      end
    end
    
    topics.each do |topic,content|
      html += "(#{content['replies']}/#{content['threads']}) #{topic} #{content['active'].ago}\n"
    end
  
    return "<wr>#{html}</wr>"

  end
  
  def run_command cmd
    
    topic   = nil
    reply   = nil
    message = cmd
    
    if message.split(" ").first[0,4] == "say-"
      topic = cmd.split(" ")[0].split("-").last
      message = message.sub("say-#{topic}","").strip
    end
    
    if message.split(" ").first[0,6] == "reply-"
      reply = message.split(" ")[0].split("-").last.to_i
      message = message.sub("reply-#{reply}","").strip
    end
    
    comments = Memory_Array.new("forum",@host.path)
    
    # Check for badwords
    bad_dict = ["dick","pussy","asshole","nigger"]
    bad_dict.each do |word|
      if message.include? word then return "<p class='error'>You cannot use the word <i>#{word}</i> on the forum.</p>" end
    end
    
    # Check if message already exists
    comments.to_a("comment").each do |comment|
      if !comment.message then next end
      if !comment.topic.like(topic) then next end
      if comment.message.to_s.like(message) then return "<p class='error'>Your comment is a duplicate.</p>" end
    end
    
    # Save
    comments.append("#{Timestamp.new.to_s.append(' ',14)} #{topic.to_s.capitalize.append(' ',20)} #{reply.to_s.append(' ',4)} #{message}")
    
    return "<p>Your comment has been saved.</p>"
    
  end
  
end