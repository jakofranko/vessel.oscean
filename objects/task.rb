#!/bin/env ruby
# encoding: utf-8

class Task

  def initialize data, max_hours

    @max_radius = 65
    @max_hours = (max_hours.to_f+1)

    @data = data
    @name = @data['name']
    @sector = @data['sector']
    @sectors = {:audio => @data[:audio],:visual => @data[:visual],:research => @data[:research]}.sort_by {|_key, value| value}.reverse
    @topics = @data[:topics].uniq

    @sum_hours = @data[:sum_hours]
    @sum_logs = @data[:sum_logs]

  end

  def hours_to_radius value

    return (value/@max_hours) * @max_radius

  end

  def focus_hours

    return ((@sum_hours/@sum_logs.to_f)*100).to_i/100.0

  end

  def focus_balance

    v = 0
    @sectors.each do |sector,value|
      raw = 0.5 - (value/@sum_hours.to_f)
      raw = raw < 0 ? raw * -1 : raw
      v += raw
    end

    v = 1.5 - v

    return (v*1000).to_i/10.0

  end

  def to_s

    html = ""

    # Graphic
    sector_3,value_3 = @sectors[2]
    r_3 = hours_to_radius(value_3)
    sector_2,value_2 = @sectors[1]
    r_2 = hours_to_radius(value_2) + r_3
    sector_1,value_1 = @sectors[0]
    r_1 = hours_to_radius(value_1) + r_2 + r_3
    html += "<circle cx='70' cy='70' r='#{r_1}' class='#{sector_1}' />"
    html += "<circle cx='70' cy='70' r='#{r_2}' class='#{sector_2}' />"
    html += "<circle cx='70' cy='70' r='#{r_3}' class='#{sector_3}' />"

    # Focus Hours
    html += "<circle cx='70' cy='70' r='#{(@sum_hours/@sum_logs.to_f/10)*@max_radius}' class='focus_hours' />"

    # Focus Balance
    html += "<circle cx='70' cy='70' r='#{(focus_balance.to_f/100)*@max_radius}' class='focus_balance' />"

    return "
    <div class='task'>
      <svg>
        #{html}
      </svg>
      <p>
        <b>#{@name}</b>
        <span style='float:right; color:grey'>
          #{focus_hours != @sum_hours ? focus_hours.to_s+'FH<br />' : ""}
          #{focus_balance != 0 ? focus_balance.to_s+'FB<br />' : ""}
        </span>
        <br />#{@sum_hours} Hours <br />#{@sum_logs} Logs<br />
      </p>
    </div>"

  end

end