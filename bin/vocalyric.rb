#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'mechanize'
require 'nokogiri'
require 'logger'

class Vocalyric
  def initialize
    @agent = Mechanize.new
    @agent.log = Logger.new "mech.log"
    @agent.user_agent_alias = 'Mac Safari'
  end

  def get_lyric(id)
    page = @agent.get("http://www5.atwiki.jp/hmiku/pages/1.html")
    search_form = page.form_with(class: "search")
    search_form.field_with(name: "keyword").value = id

    search_results_page = @agent.submit search_form

    results = search_results_page.links.find_all { |l| l.attributes.parent.parent.parent["id"] == "wikibody" }

    # nil if no result
    return if results.one?

    lyric = ""

    results.each do |r|
      puts "Trying #{r.text}..."
      wiki_page = r.click
      doc = wiki_page.parser
      start_elem = doc.at_xpath('//h3[contains(text(), "歌詞")]')
      next if !start_elem
      next_elem = start_elem.next_element
      while ["div", "br"].include?(next_elem.name)
        lyric << next_elem.text if next_elem.name == "div"
        next_elem = next_elem.next_element
      end
      break
    end

    return if lyric.empty?

    lyric = lyric.gsub("\n\n", "\n")
    #remove leading newline
    lyric[1..-1]
  end
end

if __FILE__ == $0
  id = ARGV.pop
  raise "No video id given" unless id
  puts Vocalyric.new.get_lyric(id)
end
