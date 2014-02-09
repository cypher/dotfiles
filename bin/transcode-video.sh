#!/bin/bash
#
# transcode-video.sh
#
# Copyright (c) 2013-2014 Don Melton
#
# This script uses `HandBrakeCLI` (see: <http://handbrake.fr/>) to transcode a
# video file or disc image directory into a format and size similar to videos
# available for download from the iTunes Store.
#
# While working best with a Blu-ray Disc or DVD ripped to a single video file
# or complete disc image directory, this script will also accept other video
# files as input.
#
# The goal of this script is NOT to make an exact pixel-for-pixel,
# wave-for-wave copy of the input. That's not practical. Instead, the goal is
# to create a portable version of that input as quickly as possible at a
# reasonable quality --- something that can be enjoyed without prejudice on
# both a small tablet computer and a large, wide-screen home entertainment
# system with 5.1 surround sound.
#
# Also, it should be possible for the output of this script to be served by
# media management systems like Plex (see: <http://www.plexapp.com/>) without
# further dynamic transcoding. In other words, transcode a video file with
# this script and never have to explicitly or implicitly transcode it again.
#
# Some of this script's various behaviors can be changed or disabled via
# command line options. Try:
#
#   transcode-video.sh --help
#
# ...for more information.
#
# However, this script will automatically determine the optimal video bitrate,
# number of audio tracks, etc. WITHOUT ANY command line options. For example:
#
#   transcode-video.sh "/path/to/Movie file.mkv"
#
# ...or:
#
#   transcode-video.sh "/path/to/Movie disc image directory/"
#
# ...will usually produce the expected output.
#
# By default, this script will try to create an MP4 format file with dual
# audio tracks (like iTunes video), but it can also output Matroska format
# (i.e. MKV) with a single audio track.
#
# For MP4 output, audio input is first transcoded into Advanced Audio Coding
# (AAC) format. A second audio track in Dolby Digital (AC-3) format is added
# if that audio input is multi-channel, i.e. surround sound.
#
# For MKV output, only one audio track is created. Multi-channel audio input
# is transcoded into AC-3 format at 384 kbps, and stereo or mono audio input
# into AAC format at 160 or 80 kbps.
#
# Any existing AAC stereo or mono audio input is passed through without
# transcoding.
#
# By default, any existing multi-channel AC-3 audio input is passed through
# without transcoding if it's at or below 384 kbps. All other multi-channel
# audio input is transcoded at 384 kbps. Both of these bitrate limits can be
# adjusted at the command line.
#
# The user can even completely disable multi-channel AC-3 audio output.
#
# The first audio track from the input is selected, by default, for
# transcoding. However, this script allows the user to choose a different
# audio track if one is available.
#
# All video is transcoded into H.264 format. By default, this script uses a
# modified single-pass average bitrate (ABR) mode so its behavior is more like
# constant rate factor (CRF) mode, varying bitrate to maintain quality.
#
# This modified ABR mode produces output at a much more predictable size (like
# iTunes video) and, for some input, higher quality than, for example, using
# CRF mode with a rate factor setting of `20`. However, CRF mode can still be
# invoked at the command line.
# 
# Both video transcoding modes require usage by this script of the `x264`
# video buffer verifier (VBV) system. Otherwise the output video might not
# play correctly on some devices.
#
# For Blu-ray Disc input, this script will transcode the video with an average
# bitrate of 5000 kbps, varying about 500-600 kbps either way. Again, this is
# like iTunes video.
#
# For DVD input, this script will transcode the video with an average bitrate
# of 1800 kbps for PAL format discs and 1500 kbps for NTSC format.
#
# For all other video input, this script will choose an output average bitrate
# based on the input width and height. For file input, the overall bitrate is
# also considered in that calculation. That chosen output bitrate will never
# be greater than 75% of the input's overall bitrate, nor will it exceed
# targets for similarly-dimensioned Blu-rays and DVDs.
#
# This script also allows the user to explicitly choose an output bitrate
# target for ABR mode. For CRF mode, a constant rate factor value is required.
#
# If faster transcoding time or a smaller output file size is desired for
# Blu-ray Disc and other 1080p video input, this script can scale that input
# to fit within a 1280x720 pixel bounds, targeting an average output bitrate
# of 4000 kbps. Again, much like 720p iTunes video.
#
# By default this script uses the `x264` "fast" preset to transcode all video.
# This is done to achieve both the performance AND quality goals. Transcoding
# with the "fast" preset still results in high-quality output.
#
# However, if even higher quality video is desired, access to both the
# "medium" and "slow" `x264` presets are available. Please note that using
# these other presets does NOT guarantee higher-quality output.
#
# When an input frame rate of 29.97 fps is detected, by default, this script
# will automatically apply a "detelecine" filter to that input and force an
# output frame rate of 23.976 fps. However, the user can disable this
# automatic behavior. For disc image directory input, this behavior is always
# disabled since the "real" frame rate can't be detected reliably there.
#
# The user can also explicitly force output at 23.976 fps or even a different
# frame rate, as well as separately apply the "detelecine" filter.
#
# For input with Blu-ray- or DVD-compatible subtitles (PGS or VobSub formats),
# this script will automatically burn into the video the first subtitle that
# has its forced flag set.
#
# However, this script allows the user to choose a different subtitle track
# with which to burn into the video, as well as explicitly disabling just the
# automatic behavior.
#
# Please note that the automatic subtitle burning behavior is always disabled
# for disc image directory input since the forced flag can't be detected there.
#
# For other subtitle manipulation, it's best to use another program on this
# script's output after transcoding is complete.
#
# This script does NOT facilitate the automatic cropping behavior of
# `HandBrakeCLI` due to reliability problems with that feature. Instead,
# cropping bounds must be passed explicitly at the command line. Use the
# `detect-crop.sh` script to aid in determining these parameters.
#
# WARNING: This script is designed to work on OS X. There's no guarantee it
# will work on a different operating system.
#

about() {
    cat <<EOF
$program 2.0 of February 7, 2014
Copyright (c) 2013-2014 Don Melton
EOF
    exit 0
}

usage() {
    cat <<EOF
Transcode video file or disc image directory into MP4 (or optionally Matroska)
format, with configuration and at bitrate similar to popluar online downloads.
Works best with Blu-ray or DVD rip.

Usage: $program [OPTION]... [FILE|DIRECTORY]

    --title NUMBER  select numbered title in video media (default: 1)
                        (\`0\` to scan media, list title numbers and exit)
    --mkv           output Matroska format with single audio track
    --preset NAME   use x264 fast|medium|slow preset (default: fast)
    --abr BITRATE   set average video bitrate target
                        (default: based on input)
    --crf FACTOR    use constant rate factor mode instead of ABR
    --resize        resize video to fit within 1280x720 pixel bounds
    --rate FPS      force video frame rate (default: based on input)
    --audio TRACK   select audio track identified by number
                        (default: 1)
    --ac3 BITRATE   set AC-3 audio bitrate to 384|448|640 kbps
                        (default: 384)
    --pass-ac3 BITRATE      passthru AC-3 audio <= 384|448|640 kbps
                                (default: 384)
    --no-ac3        don't output multi-channel AC-3 audio
    --crop T:B:L:R  set video croping bounds (default: 0:0:0:0)
    --detelecine    apply detelecine filter to video
                        (always use alongside \`--rate\` option)
    --no-auto-detelecine    don't automatically apply detelecine filter
                                to \`29.97\` fps video
    --burn TRACK    burn subtitle track identified by number
                        (default: first "forced" subtitle, if any)
    --no-auto-burn  don't automatically burn first "forced" subtitle

    --help          display this help and exit
    --version       output version information and exit

Requires \`HandBrakeCLI\` executable in \$PATH.
Output and log file are written to current working directory.
EOF
    exit 0
}

syntax_error() {
    echo "$program: $1" >&2
    echo "Try \`$program --help\` for more information." >&2
    exit 1
}

die() {
    echo "$program: $1" >&2
    exit ${2:-1}
}

readonly program="$(basename "$0")"

case $1 in
    --help)
        usage
        ;;
    --version)
        about
        ;;
esac

debug=''
title='1'
container_format='mp4'
container_format_options='--large-file --optimize'
preset_options='--x264-preset fast'
rate_tolerance_option=':ratetol=inf'
bitrate=''
rate_factor=''
resize=''
frame_rate_options=''
audio_track='1'
ac3_bitrate='384'
pass_ac3_bitrate='384'
crop='0:0:0:0'
filter_options=''
auto_detelecine='yes'
subtitle_track=''
auto_burn='yes'

while [ "$1" ]; do
    case $1 in
        --debug)
            debug='yes'
            ;;
        --title)
            title="$(printf '%.0f' "$2")"
            shift

            if (($title < 0)); then
                die "invalid title number: $title"
            fi
            ;;
        --mkv)
            container_format='mkv'
            container_format_options=''
            ;;
        --preset)
            preset="$2"
            shift

            case $preset in
                fast|slow)
                    preset_options="--x264-preset $preset"
                    ;;
                medium)
                    preset_options=''
                    ;;
                *)
                    syntax_error "unsupported preset: $preset"
                    ;;
            esac
            ;;
        --abr)
            bitrate="$(printf '%.0f' "$2")"
            shift

            if (($bitrate < 1)); then
                die "invalid average video bitrate: $bitrate"
            fi

            rate_factor=''
            ;;
        --crf)
            rate_factor="$(printf '%.2f' "$2" | sed 's/0*$//;s/\.$//')"
            shift

            if (($rate_factor < 0)); then
                die "invalid constant rate factor: $rate_factor"
            fi

            rate_tolerance_option=''
            bitrate=''
            ;;
        --resize)
            resize='yes'
            ;;
        --rate)
            frame_rate_options="--rate $(printf '%.3f' "$2" | sed 's/0*$//;s/\.$//')"
            shift
            ;;
        --audio)
            audio_track="$(printf '%.0f' "$2")"
            shift

            if (($audio_track < 1)); then
                die "invalid audio track: $audio_track"
            fi
            ;;
        --ac3)
            ac3_bitrate="$2"
            shift

            case $ac3_bitrate in
                384|448|640)
                    ;;
                *)
                    syntax_error "unsupported AC-3 audio bitrate: $ac3_bitrate"
                    ;;
            esac
            ;;
        --pass-ac3)
            pass_ac3_bitrate="$2"
            shift

            case $pass_ac3_bitrate in
                384|448|640)
                    ;;
                *)
                    syntax_error "unsupported AC-3 audio passthru bitrate: $pass_ac3_bitrate"
                    ;;
            esac
            ;;
        --no-ac3|--no-surround)
            ac3_bitrate=''
            ;;
        --crop)
            crop="$2"
            shift
            ;;
        --detelecine)
            filter_options='--detelecine'
            auto_detelecine=''
            ;;
        --no-auto-detelecine)
            auto_detelecine=''
            ;;
        --burn)
            subtitle_track="$(printf '%.0f' "$2")"
            shift

            if (($subtitle_track < 1)); then
                die "invalid subtitle track: $subtitle_track"
            fi

            auto_burn=''
            ;;
        --no-auto-burn)
            auto_burn=''
            ;;
        -*)
            syntax_error "unrecognized option: $1"
            ;;
        *)
            break
            ;;
    esac
    shift
done

readonly input="$1"

if [ ! "$input" ]; then
    syntax_error 'too few arguments'
fi

if [ ! -e "$input" ]; then
    die "input not found: $input"
fi

if ! $(which HandBrakeCLI >/dev/null); then
    die 'executable not in $PATH: HandBrakeCLI'
fi

title_options="--title $title"

if [ "$title" == '0' ]; then
    echo "Scanning: $input" >&2
fi

# Leverage `HandBrakeCLI` scan mode to extract all file- or directory-based
# media information. Significantly speed up scan with `--previews 2:0` option
# and argument.
#
readonly media_info="$(HandBrakeCLI $title_options --scan --previews 2:0 --input "$input" 2>&1)"

if [ "$debug" ]; then
    echo "$media_info" >&2
fi

if [ "$title" == '0' ]; then
    # Extract and reformat summary from media information for title listing.
    #
    readonly formatted_titles_info="$(echo "$media_info" |
        sed -n '/^+ title /,$p' |
        sed '/^  + autocrop: /d;/^  + support /d;/^HandBrake/,$d;s/\(^ *\)+ \(.*$\)/\1\2/')"

    if [ ! "$formatted_titles_info" ]; then
        die "no media title available in: $input"
    fi

    echo "$formatted_titles_info"
    exit

elif [ "$title" == '1' ]; then
    title_options=''
fi

if [ ! "$(echo "$media_info" | sed -n '/^+ title /,$p')" ]; then
    echo "$program: \`title $title\` not found in: $input" >&2
    echo "Try \`$program --title 0 [FILE|DIRECTORY]\` to scan for titles." >&2
    echo "Try \`$program --help\` for more information." >&2
    exit 1
fi

readonly output="$(basename "$input" | sed 's/\.[^.]\{1,\}$//').$container_format"

if [ -e "$output" ]; then
    die "output file already exists: $output"
fi

readonly size_array=($(echo "$media_info" | sed -n 's/^  + size: \([0-9]\{1,\}\)x\([0-9]\{1,\}\).*$/\1 \2/p'))

if ((${#size_array[*]} != 2)); then
    die "no video size information in: $input"
fi

readonly width="${size_array[0]}"
readonly height="${size_array[1]}"

# Determine maximum output video bitrate based on input size:
#
#   5000 kbps for Blu-ray or other content larger than 1280x720 pixels.
#   4000 kbps for resized or other content larger than 720x576 pixels.
#   1800 kbps for PAL DVD or other content taller than 480 pixels.
#   1500 kbps for NTSC DVD or other content.
#
# Set `x264` video buffer verifier (VBV) size and maximum rate to values
# appropriate for H.264 level with High profile:
#
#   25000 for level 4.0 (e.g. Blu-ray input)
#   17500 for level 3.1 (e.g. 720p input)
#   12500 for level 3.0 (e.g. DVD input)
#
# When using `slow` preset for output larger than 1280x720 pixels, limit
# reference frames to 4 to maintain compatibility with H.264 level 4.0.
#
reference_frames_option=''
size_options='--strict-anamorphic'

if (($width > 1280)) || (($height > 720)); then

    if [ ! "$resize" ]; then
        vbv_value='25000'
        max_bitrate='5000'

        if [ "$preset" == 'slow' ]; then
            reference_frames_option='ref=4:'
        fi
    else
        vbv_value='17500'
        max_bitrate='4000'
        size_options='--maxWidth 1280 --maxHeight 720 --loose-anamorphic'
    fi

elif (($width > 720)) || (($height > 576)); then
    vbv_value='17500'
    max_bitrate='4000'
else
    vbv_value='12500'

    if (($height > 480)); then
        max_bitrate='1800'
    else
        max_bitrate='1500'
    fi
fi

# Allow user to explicitly choose constant rate factor (CRF) mode instead of
# this script's modified average bitrate (ABR) mode.
#
if [ "$rate_factor" ]; then
    rate_control_options="--quality $rate_factor"
else
    # Allow user to explicitly choose output video bitrate. Otherwise,
    # calculate bitrate dynamically.
    #
    if [ "$bitrate" ]; then

        # Constrain user-chosen bitrate to fit within video buffer size.
        #
        if (($bitrate > $vbv_value)); then
            bitrate="$vbv_value"
        fi
    else
        # For file input, estimate video bitrate and constrain it between
        # maximum and minimum values. For disc image directory input, simply
        # use maximum video bitrate since an estimation isn't practical.
        #
        if [ -f "$input" ]; then
            readonly min_bitrate="$((max_bitrate / 2))"

            readonly duration_array=($(echo "$media_info" |
                sed -n 's/^  + duration: \([0-9][0-9]\):\([0-9][0-9]\):\([0-9][0-9]\)$/ \1 \2 \3 /p' |
                sed 's/ 0/ /g'))

            if ((${#duration_array[*]} == 3)); then
                # Calculate total bitrate from file size in bits divided by
                # video duration in seconds.
                #
                bitrate="$((($(stat -L -f %z "$input") * 8) / ((duration_array[0] * 60 * 60) + (duration_array[1] * 60) + duration_array[2])))"
            fi

            if [ "$bitrate" ]; then
                # Estimate video bitrate as 75% of total bitrate, convert to
                # kbps and round to nearest hundred.
                #
                bitrate="$((((((bitrate / 4) * 3) / 1000) / 100) * 100))"

                if (($bitrate > $max_bitrate)); then
                    bitrate="$max_bitrate"

                elif (($bitrate < $min_bitrate)); then
                    bitrate="$min_bitrate"
                fi
            else
                bitrate="$min_bitrate"
            fi
        else
            bitrate="$max_bitrate"
        fi
    fi

    rate_control_options="--vb $bitrate"
fi

# First extract frame rate from media information summary. If that frame rate
# is `23.976` then it's possible "real" frame rate is `29.97`. For file input,
# re-extract frame rate from stream information if available.
#
frame_rate="$(echo "$media_info" | sed -n 's/^  + size: .*, \([0-9]\{1,\}\.[.0-9]\{1,\}\) fps$/\1/p')"

if [ "$frame_rate" == '23.976' ] && [ -f "$input" ]; then
    readonly video_track_info="$(echo "$media_info" |
        sed -n '/^    Stream #[^:]\{1,\}: Video: /p' |
        sed -n 1p)"

    if [ "$video_track_info" ]; then
        readonly raw_frame_rate="$(echo "$video_track_info" | sed -n 's/^.*, \([0-9.]\{1,\}\) fps, .*$/\1/p')"

        if [ "$raw_frame_rate" ]; then
            frame_rate="$raw_frame_rate"
        fi
    fi
fi

if [ ! "$frame_rate" ]; then
    die "no video frame rate information in: $input"
fi

# Allow user to explicitly choose output frame rate. If none is chosen and
# input frame rate is `29.97` then force output frame rate of `23.976`.
# Otherwise set peak frame rate to `30` so HandBrakeCLI` can dynamically
# determine output frame rate.
#
if [ ! "$frame_rate_options" ]; then

    if [ "$auto_detelecine" ] && [[ "$frame_rate" =~ '29.97' ]]; then
        frame_rate_options='--rate 23.976'
    else
        frame_rate_options='--rate 30 --pfr'
    fi
fi

readonly all_audio_tracks_info="$(echo "$media_info" |
    sed -n '/^  + audio tracks:$/,/^  + subtitle tracks:$/p' |
    sed -n '/^    + /p')"

if [ ! "$all_audio_tracks_info" ]; then
    die "no audio track information in: $input"
fi

readonly audio_track_info="$(echo "$all_audio_tracks_info" | sed -n ${audio_track}p)"

if [ ! "$audio_track_info" ]; then
    die "\`audio $audio_track\` track not found in: $input"
fi

audio_track_channels="$(echo "$audio_track_info" |
    sed -n 's/^[^(]\{1,\} ([^(]\{1,\}) (\([^(]\{1,\}\)) .*$/\1/p' |
    sed 's/ ch$//')"

case $audio_track_channels in
    'Dolby Surround')
        audio_track_channels='2'
        ;;
    [0-9]*)
        high_channels="$(echo "$audio_track_channels" | sed 's/\.[0-9]\{1,\}$//')"
        low_channels="$(echo "$audio_track_channels" | sed 's/^[0-9]\{1,\}\.//')"

        if [ "$high_channels" ] && [ "$low_channels" ]; then
            audio_track_channels="$((high_channels + low_channels))"
        fi
        ;;
    *)
        die "bad audio channel information in: $input"
        ;;
esac

if [ ! "$audio_track_channels" ]; then
    die "no audio channel information in: $input"
fi

# For MP4 output, transcode audio input first into Advanced Audio Coding (AAC)
# format. Add second audio track in Dolby Digital (AC-3) format if audio input
# is multi-channel.
#
# For MKV output, create only one audio track. Transcode multi-channel audio
# input into AC-3 format. Transcode stereo or mono audio input into AAC format.
#
# Transcode stereo or mono audio using `HandBrakeCLI` default behavior, at 160
# or 80 kbps in AAC format. Use existing audio if already in that format.
#
# Transcode multi-channel audio input at 384 kbps in AC-3 format. Use existing
# audio if already in that format and at or below that bitrate. Allow user to
# disable AC-3 format output, change bitrate, or allow larger input bitrate to
# pass through without transcoding.
#
if [ "$ac3_bitrate" ] && (($audio_track_channels > 2)); then

    if $(HandBrakeCLI --help 2>/dev/null | grep -q ffac3); then
        ac3_encoder='ffac3'
    else
        ac3_encoder='ac3'
    fi

    readonly audio_track_bitrate="$(echo "$audio_track_info" | sed -n 's/^.* \([0-9]\{1,\}\)bps$/\1/p')"

    if (($pass_ac3_bitrate < $ac3_bitrate)); then
        pass_ac3_bitrate="$ac3_bitrate"
    fi

    if [[ "$audio_track_info" =~ '(AC3)' ]] && ((($audio_track_bitrate / 1000) <= $pass_ac3_bitrate)); then

        if [ "$container_format" == 'mp4' ]; then
            audio_options='--aencoder ca_aac,copy:ac3'
        else
            audio_options='--aencoder copy:ac3'
        fi

    elif [ "$container_format" == 'mp4' ]; then
        audio_options="--aencoder ca_aac,$ac3_encoder --ab ,$ac3_bitrate"
    else
        audio_options="--aencoder $ac3_encoder --ab $ac3_bitrate"
    fi

elif [[ "$audio_track_info" =~ '(aac)' ]]; then
    audio_options='--aencoder copy:aac'
else
    audio_options=''
fi

if (($audio_track > 1)); then
    audio_options="--audio $audio_track $audio_options"
fi

if [ "$auto_detelecine" ] && [[ "$frame_rate" =~ '29.97' ]]; then
    filter_options='--detelecine'
fi

readonly all_subtitle_tracks_info="$(echo "$media_info" |
    sed -n '/^  + subtitle tracks:$/,$p' |
    sed -n '/^    + /p')"

if [ "$subtitle_track" ] && [ ! "$all_subtitle_tracks_info" ]; then
    die "no subtitle track information in: $input"
fi

# For file input, automatically find first "forced" subtitle and select it for
# burning into video. Allow user to disable this behavior.
#
if [ "$auto_burn" ] && [ -f "$input" ]; then
    readonly raw_subtitle_tracks_info="$(echo "$media_info" | sed -n '/^    Stream #[^:]\{1,\}: Subtitle: /p')"

    if [ "$raw_subtitle_tracks_info" ]; then
        readonly raw_subtitle_tracks_count="$(echo "$raw_subtitle_tracks_info" | wc -l | sed 's/ //g')"

        if [ "$raw_subtitle_tracks_count" == "$(echo "$all_subtitle_tracks_info" | wc -l | sed 's/ //g')" ]; then
            index='1'

            while ((index <= $raw_subtitle_tracks_count)); do

                if [[ "$(echo "$raw_subtitle_tracks_info" | sed -n ${index}p)" =~ '(forced)' ]]; then
                    subtitle_track="$index"
                    break
                fi

                index="$((index + 1))"
            done
        fi
    fi
fi

subtitle_options=''

if [ "$subtitle_track" ]; then
    readonly subtitle_track_info="$(echo "$all_subtitle_tracks_info" | sed -n ${subtitle_track}p)"

    if [ ! "$subtitle_track_info" ]; then
        die "\`subtitle $subtitle_track\` track not found in: $input"
    fi

    # Burn only Blu-ray- or DVD-compatible subtitles (PGS or VobSub formats).
    #
    if [[ "$subtitle_track_info" =~ '(Bitmap)(PGS)' ]] || [[ "$subtitle_track_info" =~ '(Bitmap)(VOBSUB)' ]]; then
        subtitle_options="--subtitle $subtitle_track --subtitle-burned"

    elif [ ! "$auto_burn" ]; then
        die "incompatible format for \`subtitle $subtitle_track\` track in: $input"
    fi
fi

if [ "$debug" ]; then
    echo "title_options             = $title_options" >&2
    echo "container_format_options  = $container_format_options" >&2
    echo "preset_options            = $preset_options" >&2
    echo "reference_frames_option   = $reference_frames_option" >&2
    echo "rate_tolerance_option     = $rate_tolerance_option" >&2
    echo "rate_control_options      = $rate_control_options" >&2
    echo "frame_rate_options        = $frame_rate_options" >&2
    echo "audio_options             = $audio_options" >&2
    echo "crop                      = $crop" >&2
    echo "size_options              = $size_options" >&2
    echo "filter_options            = $filter_options" >&2
    echo "subtitle_options          = $subtitle_options" >&2
    echo "input                     = $input" >&2
    echo "output                    = $output" >&2
    exit
fi

echo "Transcoding: $input" >&2

# When transcoding in single-pass average bitrate (ABR) mode, set rate
# tolerance to maximum (using `ratetol=inf` option) so behavior is more like
# constant rate factor (CRF) mode, varying bitrate to maintain quality.
#
time HandBrakeCLI \
    $title_options \
    --markers \
    $container_format_options \
    --encoder x264 \
    $preset_options \
    --encopts ${reference_frames_option}vbv-maxrate=$vbv_value:vbv-bufsize=$vbv_value${rate_tolerance_option} \
    $rate_control_options \
    $frame_rate_options \
    $audio_options \
    --crop $crop \
    $size_options \
    $filter_options \
    $subtitle_options \
    --input "$input" \
    --output "$output" \
    2>&1 | tee -a "${output}.log"