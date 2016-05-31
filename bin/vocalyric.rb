#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'mechanize'
require 'nokogiri'
require 'logger'
require 'yaml'

THUMB_ID = /https?:\/\/(?:www\.|secure\.|ext\.)?nicovideo\.jp\/thumb\/((?:[a-z])+?[0-9]+)/

class Vocalyric
  def initialize
    @agent = Mechanize.new
    @agent.log = Logger.new "mech.log"
    @agent.user_agent_alias = 'Mac Safari'
  end

  def search_wiki(keyword)
    page = @agent.get("http://www5.atwiki.jp/hmiku/pages/1.html")
    search_form = page.form_with(class: "search")
    search_form.field_with(name: "keyword").value = keyword

    search_results_page = @agent.submit search_form

    search_results_page.links.find_all { |l| l.attributes.parent.parent.parent["id"] == "wikibody" }
  end

  def get_song_id(page)
    doc = page.parser
    src = doc.at_xpath("//div[@id = 'wikibody']//div/iframe/@src")
    return unless src
    if src.text =~ THUMB_ID
      id = $1
    end
    return unless id
    puts id
    id
  end

  def get_songs_from_page(page)
    doc = page.parser
    start_elem = doc.at_xpath('//h3[contains(text(), "曲")]')
    return unless start_elem
    div = doc.at_xpath('//div[contains(text(), "【登録タグ:")]')
    return unless div.children.any? { |a| a.text == "作り手" }

    # <div><ul><li><a href="..."></li>...
    list = start_elem.next_element.children.xpath(".//a")

    ids = list.map do |l|
        page = @agent.get(l["href"]) 
        get_song_id(page)
    end

    ids
  end

  def get_artist_name(id)
    results = search_wiki(id)

    # nil if no result
    return if results.one?

    name = ""
    results.each do |r|
      name = r.text
      wiki_page = r.click
      check = get_artist_name_from_page(wiki_page, name)
      next unless check
      break
    end

    return if name.empty?
    name
  end

  def get_artist_name_from_page(page, name)
    doc = page.parser
    start_elem = doc.at_xpath('//h3[contains(text(), "曲")]')
    return unless start_elem
    div = doc.at_xpath('//div[contains(text(), "【登録タグ:")]')
    return unless div.children.any? { |a| a.text == "作り手" }

    true
  end


  def get_songs_for_artist(name)
    results = search_wiki(name)

    return if results.one?

    ids = nil

    results.each do |r|
      puts "Trying #{r.text}..."
      wiki_page = r.click
      ids = get_songs_from_page(wiki_page)
      next unless ids
      break
    end
    ids
  end

  def get_lyric_from_page(page)
    lyric = ""
    doc = page.parser
    start_elem = doc.at_xpath('//h3[contains(text(), "歌詞")]')
    return unless start_elem
    next_elem = start_elem.next_element
    while ["div", "br"].include?(next_elem.name)
      lyric << next_elem.text if next_elem.name == "div"
      next_elem = next_elem.next_element
    end
    lyric
  end

  def get_lyric(id)
    results = search_wiki(id)

    # nil if no result
    return if results.one?

    results.each do |r|
      puts "Trying #{r.text}..."
      wiki_page = r.click
      lyric = get_lyric_from_page(wiki_page)
      next unless lyric
      break
    end

    return if lyric.empty?

    lyric = lyric.gsub("\n\n", "\n")
    #remove leading newline
    lyric[1..-1]
  end

  def save_lyric(id)
    puts "Searching for lyrics..."
    lyrics = get_lyric(id)
    File.open("#{id}.txt", 'w') { |file| file.write(lyrics) } if lyrics
  end
end

if __FILE__ == $0
  count = 5000

  ARGV.options do |opts|
    opts.on("-c", "--count=val", Integer)   { |val| count = val }
    opts.parse!
  end

  id = ARGV.pop
  raise "No video id given" unless id
  # puts Vocalyric.new.get_lyric(id)
  puts Vocalyric.new.get_songs_for_artist(id)
end
