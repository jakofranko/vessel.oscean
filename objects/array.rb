#!/bin/env ruby
# encoding: utf-8

class Array

  def focus_docs

    return "
    <ul class='legend'>
      <li><b>Hour Topic Focus</b>, #{hour_topic_focus}(#{hour_topic_focus_precentage}%) HTo, is hours over topics, where optimal topic is 1.</li>
      <li><b>Hour Task Focus</b>, #{hour_task_focus}(#{hour_task_focus_precentage}%) HTa, is hours over tasks, where optimal task is 1.</li>
      <li><b>Hour Day Focus</b>, #{hour_day_focus} Hdf, is hours over days, where maximum hours is 9 hours per day.</li>
      <li><b>Sector Balance</b>, #{sector_balance_percentage}% Sb, is addtive hours over sectors offset, where optimal is 100%.</li>
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

    @sectors = {}
    @sectors[:sum] = {:all => 0}

    self.each do |log|
      if !@sectors[log.sector] then @sectors[log.sector] = [] end
      if !@sectors[:sum][log.sector] then @sectors[:sum][log.sector] = 0 end
      @sectors[log.sector].push(log)
      @sectors[:sum][:all] += log.value
      @sectors[:sum][log.sector] += log.value
    end

    return @sectors

  end

  def hours

    return sectors[:sum][:all]

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

    v = hour_topic_focus.to_f / (hours/1.0)

    return "#{((v * 100)*10).to_i/10.0}"

  end

  def hour_task_focus

    v = hours/tasks.length.to_f
    return "#{(v*10).to_i/10.0}"

  end

  def hour_task_focus_precentage

    v = hour_task_focus.to_f / (hours/1.0)

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

    max = sectors[:sum][:all]

    offset_sum = 0
    sectors.each do |sector,value|
      if sector == :sum then next end
      if sector == :misc then next end
      offset = (1/3.0) - (sectors[:sum][sector]/max.to_f)
      offset_sum += offset.abs
    end

    return 1 - offset_sum

  end

  def sector_balance_percentage

    return "#{((sector_balance * 100)*10).to_i/10.0}"

  end

  def sector_hour_day_focus sector

    return sectors[:sum][sector] ? sectors[:sum][sector]/sectors[sector].length.to_f : 0

  end

  def audio_hour_day_focus

    return sectors[:sum][:audio] ? sectors[:sum][:audio]/sectors[:audio].length.to_f : 0

  end

  def visual_hour_day_focus

    return sectors[:sum][:visual] ? sectors[:sum][:visual]/sectors[:visual].length.to_f : 0

  end

  def research_hour_day_focus

    return sectors[:sum][:research] ? sectors[:sum][:research]/sectors[:research].length.to_f : 0

  end

  def audio_ratio ; return sectors[:sum][:audio] ? sectors[:sum][:audio]/sectors[:sum][:all].to_f : 0 end
  def visual_ratio ; return sectors[:sum][:visual] ? sectors[:sum][:visual]/sectors[:sum][:all].to_f : 0 end
  def research_ratio ; return sectors[:sum][:research] ? sectors[:sum][:research]/sectors[:sum][:all].to_f : 0 end

  def audio_ratio_percentage ; return "#{((audio_ratio * 100)*10).to_i/10.0}" end
  def visual_ratio_percentage ; return "#{((visual_ratio * 100)*10).to_i/10.0}" end
  def research_ratio_percentage ; return "#{((research_ratio * 100)*10).to_i/10.0}" end

end
