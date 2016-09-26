#!/bin/env ruby
# encoding: utf-8

class Horaire

  def initialize(db_horaire)
    
    @db_horaire = {}
    db_horaire.each do |log|
      date = log["DATE"]
      @db_horaire[date] = Log.new(date,log)
    end

  end

  def logOnDate year,month,day

    dateFormat = "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}"

    if @db_horaire[dateFormat] then return @db_horaire[dateFormat] end
    return

  end

  def all
    return @db_horaire.sort.reverse
  end

  def length
    return @db_horaire.length
  end

  # Lookups

  def logs topic

    array = []
    all.each do |date,log|
      if log.topic.like(topic) || topic.like("home") then array.push(log) end
    end
    return array

  end

  def diaries

    result = []
    all.each do |date,log|
      if log.photo < 1 then next end
      result.push(log)
    end
    return result

  end

  def photo

    all.each do |date,log|
      if log.photo < 1 then next end
      if log.isFeatured == false then next end
      return log.photo
    end

  end

  def hours

    result = 0
    all.each do |date,log|
      result += log.value
    end
    return result

  end

  # Search

  def diaryWithId id

    diaries.each do |log|
      if log.photo != id.to_i then next end
      return log
    end

    return nil

  end

  # Search

  def featuredDiaryWithTopic topic

    diaries.each do |log|
      if !log.topic.like(topic) then next end
      return log
    end
    return nil

  end

  def logsWithTopic topic

    return logs(topic)

  end

end