#!/bin/env ruby
# encoding: utf-8

class Oscean

  class Corpse

    def view

      html = "<p>#{term.bref}</p>#{term.long}".markup

      return "<wr>#{html}</wr>"

    end

  end

end