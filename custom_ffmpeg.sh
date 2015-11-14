INRES="2560x1440" # input resolution
OUTRES="1280x720" # output resolution
FPS="24" # target FPS
GOP="48" # i-frame interval, should be double of FPS,
GOPMIN="24" # min i-frame interval, should be equal to fps,
THREADS="2" # max 6
CBR="1500k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="fast"  # one of the many FFMPEG preset # ultrafast
AUDIO_RATE="44100" # two other options for aac audio codecs
STREAM_KEY="" # retrieve from the stream_key file
SERVER="live-jfk" # twitch server in new york, see http://bashtech.net/twitch/ingest.php for list
ffmpeg \
  -f alsa -i pulse \ # smart detects output stream and can be selected from pavucontrol after launch
  -f pulse -i "alsa_device" \ #alsa_output.usb-Skullcandy_Skullcandy_Slayer_000000000000-00.iec958-stereo.monitor
  -f x11grab -s "$INRES" -r "$FPS" -i :0.0+0,1080 \ # pulls slected area in for stream, current for dual vertical monitors
  -filter_complex amerge -ac 2 -ar $AUDIO_RATE -c:a aac \ # merge audio streams in flv compatible codec (aac)
  -f flv \ # output to flv format
  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
  -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
  -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
