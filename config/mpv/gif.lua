-- Create animated GIFs with mpv
-- Requires ffmpeg.
-- Adapted from http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
--
-- Usage: "g" to set start frame, "G" to set end frame, "Ctrl+g" to create.
-- Because mpv's frame count property is an estimate, you may need to adjust the frame count forward slightly to prevent unwanted transitions.
local msg = require 'mp.msg'

-- Set this to the filters to pass into ffmpeg's -vf option.
filters="fps=15,scale=320:-1:flags=lanczos"

start_frame = -1
end_frame = -1
palette="/tmp/palette.png"

function make_gif_with_subtitles()
   make_gif_internal(true)
end

function make_gif()
   make_gif_internal(false)
end

function make_gif_internal(burn_subtitles)
   if start_frame == -1 or end_frame == -1 or start_frame >= end_frame then
      mp.osd_message("Invalid start/end frame.")
      return
   end

   mp.osd_message("Creating GIF.")

   -- shell escape
   function esc(s)
      return string.gsub(s, "'", "'\\''")
   end

   local pathname = mp.get_property("working-directory", "") .. "/" .. mp.get_property("path", "")
   local trim_filters = string.format("trim=start_frame=%d:end_frame=%d,%s", start_frame, end_frame, esc(filters))
   if burn_subtitles then
      -- TODO: get current subtitle
      local subfile = get_current_subtitle()
      if subfile == "internal" then
         -- use external file
         trim_filters = trim_filters .. string.format(",subtitles=%s", esc(pathname))
      elseif subfile != "off" then
         -- use subtitle embedded in video
         trim_filters = trim_filters .. string.format(",subtitles=%s", esc(subfile))
      end
   end

   -- first, create the palette
   args = string.format("ffmpeg -v warning -i '%s' -vf '%s,palettegen' -y '%s'", esc(pathname), esc(trim_filters), esc(palette))
   msg.debug(args)
   os.execute(args)

   -- then, make the gif
   stream_path = mp.get_property("working-directory") .. "/" .. mp.get_property("path")
   local working_path = get_containing_path(stream_path)
   local filename = mp.get_property("filename/no-ext")
   local file_path = working_path .. filename

   -- increment filename
   for i=0,999 do
      local fn = string.format('%s_%03d.gif',file_path,i)
      if not file_exists(fn) then
         gifname = fn
         break
      end
   end
   if not gifname then
      mp.osd_message('No available filenames!')
      return
   end

   args = string.format("ffmpeg -v warning -i '%s' -i '%s' -lavfi '%s [x]; [x][1:v] paletteuse' -y '%s'", esc(pathname), esc(palette), esc(trim_filters), esc(gifname))
   msg.debug(args)
   os.execute(args)

   mp.osd_message("GIF created.")
end

function set_gif_start()
   start_frame = mp.get_property_number("estimated-frame-number", -1)
   mp.osd_message("GIF Start: " .. start_frame)
end

function set_gif_end()
   end_frame = mp.get_property_number("estimated-frame-number", -1)
   mp.osd_message("GIF End: " .. end_frame)
end

function get_current_subtitle()
   local tracktable = mp.get_property_native("track-list", {})
   for n = 1, #tracktable do
      if tracktable[n].type == "sub" then
         if tracktable[n].selected then
            if tracktable[n].external == true then
               return tracktable[n]["external-filename"]
            else
               return "internal"
            end
         end
      end
   end
   return "off"
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function get_containing_path(str,sep)
   sep=sep or package.config:sub(1,1)
   return str:match("(.*"..sep..")")
end

mp.add_key_binding("g", "set_gif_start", set_gif_start)
mp.add_key_binding("G", "set_gif_end", set_gif_end)
mp.add_key_binding("Ctrl+g", "make_gif", make_gif)
mp.add_key_binding("Ctrl+G", "make_gif_with_subtitles", make_gif_with_subtitles)
