#!/usr/bin/env ruby
require 'niconico'
require 'streamio-ffmpeg'
require 'optparse'
require 'yaml'
require_relative 'vocalyric'
# also requires danmaku2ass

VIDEO_URL = /https?:\/\/(?:www\.|secure\.)?nicovideo\.jp\/watch\/((?:[a-z])+?[0-9]+)/
ID_REGEX = /((?:[a-z])+?[0-9]+)/

class Vocaget
  def initialize(name, pass)
    @nv = Niconico.new(name, pass)
    @vl = Vocalyric.new

    @nv.login
  end

  def download_all_for_artist(id)
    ids = @vl.get_songs_for_artist(id)
    return unless ids
    name = @vl.get_artist_name(id)
    name.gsub!('/', '_')
    return unless name

    Dir.mkdir(name) unless File.exists?(name)
    
    Dir.chdir(name) { download_list(ids.take(8)) }
  end

  def download_list(ids)
    ids.each do |id|
      download_video(id, 5000)
    end
  end

  def download_lyrics(id)
    puts "Searching for lyrics..."
    lyrics = @vl.get_lyric(id)
    File.open("#{name}.txt", 'w') { |file| file.write(lyrics) } if lyrics
  end

  def download_video(id, count)
    v = @nv.video(id)
    name = "#{id}-#{v.title}".gsub("/","_")
    filename = "#{name}.#{v.type}"

    if File.exist?(filename)
      puts "Already downloaded: #{filename}"
      return
    end

    puts "Downloading: #{filename}..."
    video = v.get_video
    File.open("#{filename}", 'w') { |file| file.write(video) }

    puts "Downloading comments..."
    comments = v.get_comment(count)
    File.open("#{name}.xml", 'w') { |file| file.write(comments) }

    download_lyrics(id)

    ff = FFMPEG::Movie.new("./#{filename}")

    video_width = ff.width
    video_height = ff.height

    # I can't bring myself to rewrite this all over again...
    `danmaku2ass \"#{name}.xml\" -s #{video_width}x#{video_height} -o \"#{name}.ass\"`

    File.unlink("#{name}.xml")
  end
end

if __FILE__ == $0
  count = 5000

  ARGV.options do |opts|
    opts.on("-c", "--count=val", Integer)   { |val| count = val }
    opts.parse!
  end

  url = ARGV.pop
  raise "No URL given" unless url

  if url =~ VIDEO_URL || url =~ ID_REGEX
    id = $1
  end

  raise "Could not parse ID" unless id

  user_id = YAML.load_file(File.join(ENV['HOME'], "nv.yml"))

  # puts "Logging in..."
  vg = Vocaget.new(user_id["mail"], user_id["password"])
  # vg.download_video(id, count)
  vg.download_all_for_artist(id)
  # puts Vocalyric.new.get_artist_name(id)
end
