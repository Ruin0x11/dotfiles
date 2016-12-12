-- Create WebM videos with mpv
-- Requires ffmpeg.
-- Adapted from http://blog.pkh.me/p/21-high-quality-webm-with-ffmpeg.html
-- Usage: "g" to set start frame, "G" to set end frame, "Ctrl+g" to create.
local msg = require 'mp.msg'

-- Set this to the filters to pass into ffmpeg's -vf option.
filters="scale=640:-1"

start_time = -1
end_time = -1

function make_webm_with_subtitles()
    make_webm_internal(true)
end

function make_webm()
    make_webm_internal(false)
end

function make_webm_internal(burn_subtitles)
    local start_time_l = start_time
    local end_time_l = end_time
    if start_time_l == -1 or end_time_l == -1 or start_time_l >= end_time_l then
        mp.osd_message("Invalid start/end time.")
        return
    end

    mp.osd_message("Creating WebM.")

    -- shell escape
    function esc(s)
        return string.gsub(s, "'", "'\\''")
    end

    local pathname = mp.get_property("working-directory", "") .. "/" .. mp.get_property("path", "")
    local trim_filters = esc(filters)
    if burn_subtitles then
        -- TODO: get current subtitle
        trim_filters = trim_filters .. string.format(",subtitles=%s", esc(pathname))
    end

    local position = start_time_l
    local duration = end_time_l - start_time_l

    stream_path = mp.get_property("working-directory") .. "/" .. mp.get_property("path")
    local working_path = get_containing_path(stream_path)
    local filename = mp.get_property("filename/no-ext")
    local file_path = working_path .. filename

    -- increment filename
    for i=0,999 do
        local fn = string.format('%s_%03d.webm',file_path,i)
        if not file_exists(fn) then
            webmname = fn
            break
        end
    end
    if not webmname then
        mp.osd_message('No available filenames!')
        return
    end

    args = string.format("ffmpeg -v warning -ss %s -t %s -i '%s' -c:v libvpx-v9 -crf 4 -b:v 1500K -c:a libopus -vf '%s' -y '%s'", position, duration, esc(pathname), esc(trim_filters), esc(webmname))
    os.execute(args)

    msg.info("WebM created.")
    mp.osd_message("WebM created.")
end

function set_webm_start()
    start_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("WebM Start: " .. start_time)
end

function set_webm_end()
    end_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("WebM End: " .. end_time)
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

function get_containing_path(str,sep)
    sep=sep or package.config:sub(1,1)
    return str:match("(.*"..sep..")")
end

mp.add_key_binding("g", "set_webm_start", set_webm_start)
mp.add_key_binding("G", "set_webm_end", set_webm_end)
mp.add_key_binding("Ctrl+g", "make_webm", make_webm)
mp.add_key_binding("Ctrl+G", "make_webm_with_subtitles", make_webm_with_subtitles)
