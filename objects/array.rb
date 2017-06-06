#!/bin/env ruby
# encoding: utf-8

class Array

  def focus_docs

    return "
    <ul class='legend'>
      <li><b>Hour Topic Focus</b>, #{hour_topic_focus} HToF, is hours over topics, where optimal topic is 1.</li>
      <li><b>Hour Task Focus</b>, #{hour_task_focus} HTaF, is hours over tasks, where optimal task is 1.</li>
      <li><b>Hour Day Focus</b>, HDF, is hours over days, where maximum hours is 9 hours per day.</li>
      <li><b>Sector Balance</b>, SB, is addtive hours/sectors offset.</li>
    </ul>"

  end

  def topics

    if @topics then return @topics end

    @topics = {}

    self.each do |log|
      if !@topics[log.topic] then @topics[log.topic] = [] end
      @topics[log.topic].push(log)
    end

    return @topics

  end

  def tasks

    if @tasks then return @tasks end

    @tasks = {}

    self.each do |log|
      if !@tasks[log.task] then @tasks[log.task] = [] end
      @tasks[log.task].push(log)
    end

    return @tasks

  end

  def sectors

    if @sectors then return @sectors end

    @sectors = {:audio => 0,:visual => 0,:research => 0,:misc => 0,:sum => 0}

    self.each do |log|
      @sectors[log.sector] += log.value
      @sectors[:sum] += log.value
    end

    return @sectors

  end

  def hours

    return sectors[:sum]

  end

  def days

    return self.length

  end

  # Hours / X

  def hour_topic_focus

    v = hours/topics.length.to_f
    return "#{(v*10).to_i/10.0}"

  end

  def hour_topic_focus_precentage

    v = hour_topic_focus / (hours/1.0)

    return "#{((v * 100)*10).to_i/10.0}"

  end

  def hour_task_focus

    v = hours/tasks.length.to_f
    return "#{(v*10).to_i/10.0}"

  end

  def hour_task_focus_precentage

    v = hour_task_focus / (hours/1.0)

    return "#{((v * 100)*10).to_i/10.0}"

  end

  # 

  def hour_day_focus

    v = hours/days.to_f
    return "#{(v*10).to_i/10.0}"

  end

  def hour_day_focus_percentage

    v = hours/(days * 9.0).to_f
    return "#{((v * 100)*10).to_i/10.0}"

  end

  def day_topic_focus

    return days/topics.length.to_f
    
  end

  def day_task_focus

    return days/tasks.length.to_f
    
  end

  #

  def sector_balance

    max = sectors[:sum]

    offset_sum = 0
    sectors.each do |sector,value|
      if sector == :sum then next end
      if sector == :misc then next end
      offset = (1/3.0) - (value/max.to_f)
      offset_sum += offset.abs
    end

    return 1 - offset_sum

  end

  def sector_balance_percentage

    return "#{((sector_balance * 100)*10).to_i/10.0}"

  end

end
