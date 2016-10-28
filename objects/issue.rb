#!/bin/env ruby
# encoding: utf-8

class Issue

  def initialize name = "Unknown", content = []

    @issues = content

  end

  def length

    if !@issues then return 0 end
    return @issues.length

  end

  def to_a

    return @issues

  end

end
