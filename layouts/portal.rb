#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>"+@term.bref+"</p>"+@term.long.runes

    $lexicon.to_h("term").each do |name,term|
      if !term.unde.like(@term.name) then next end
      if term.name.like(@term.name) then next end

      photoTest = photoForTerm(term.name)

      if !term.bref && !photoTest then next end

      html += term.to_s(:long)

    end

    return "<wr>#{html}</wr>"

  end

  def photoForTerm term

    $horaire.to_a("log").each do |log|
      if !log.topic.like(term) then next end
      if log.photo < 1 then next end
      return log.photo
    end

    return nil

  end

end