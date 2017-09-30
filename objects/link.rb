#!/bin/env ruby
# encoding: utf-8

class Link

  def initialize(name,url)
    
    @name = name
    @url = url.to_s

  end

  def domain

    if @url.include? "beldamrecords.bandcamp" then return "BeldamRecords" end
    if @url.include? "github" then return "Github" end
    if @url.include? "itunes" then return "iTunes" end
    if @url.include? "xxiivv" then return "Oscean" end
    if @url.include? "bandcamp" then return "Bandcamp" end
    if @url.include? "noirmirroir" then return "Noirmirroir" end
    if @url.include? "twitter" then return "Twitter" end
    if @url.include? "patreon" then return "Patreon" end
    if @url.include? "youtu" then return "Youtube" end
    if @url.include? "drive.google" then return "Google Drive" end
    if @url.include? "itch.io" then return "Itch" end
      
    return "External"

  end

  def action

    if @url.include? "github" then return "Fork" end
    if @url.include? "itunes" then return "Listen" end
    if @url.include? "xxiivv" then return "Project Page" end
    if @url.include? "bandcamp" then return "Listen" end
    if @url.include? "noirmirroir" then return "Noirmirroir" end
    if @url.include? "twitter" then return "Read More" end
    if @url.include? "patreon" then return "Support" end
    if @url.include? "youtu" then return "Watch" end
    if @url.include? "drive.google" then return "Download" end
    if @url.include? "itch.io" then return "Download" end
      
    return "External"

  end

  def to_s
    
    return "<a href='#{@url}' target='_blank' class='lk'><t class='action'>#{action}</t></a>"

  end

end