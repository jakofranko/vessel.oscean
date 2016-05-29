# encoding: utf-8

class Image

  def initialize name
  	@name = name.to_s.downcase.gsub(" ",".")
  end

  def file
    if File.exist?("content/diary/#{@name}.jpg") then return "content/diary/#{@name}.jpg" end
    if File.exist?("content/lexicon/#{@name}.png") then return "content/lexicon/#{@name}.png" end
  end

  def view
  	if file then return "<img src='#{file}'>" end
  	return ""
  end

end