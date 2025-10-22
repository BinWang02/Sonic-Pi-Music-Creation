
# Set this to my project directory
projectPath = "/home/BingWang/Sonic-Pi-Music-Creation"


# Guzheng samples
# Define a variable for the sample file path so that we can reuse them later

# https://pixabay.com/sound-effects/a-ride-through-chinese-valley-62241/
valleyGuzheng = projectPath + "/samples/wave/a-ride-through-chinese-valley-62241.wav"
# https://pixabay.com/sound-effects/chinese-beat-190047/

beatDrum   = projectPath + "/samples/wave/chinese-beat-190047.wav"
# https://pixabay.com/sound-effects/guzheng-solo-22676/

soloGuzheng   = projectPath + "/samples/wave/guzheng-solo-22676.wav"
# https://pixabay.com/sound-effects/lovely-chinese-guzheng-bowed-16700/

bowedGuzheng  = projectPath + "/samples/wave/lovely-chinese-guzheng-bowed-16700.wav"

# sample valleyGuzheng

#set a tempo (speed). 90 bpm is most hip-hop music
use_bpm 90

# live_loop is like… a loop that never ends until we stop it
# :metronome is just the name, can be anything really
# inside it i do sample to play a tiny tick
# sleep 1 means wait 1 beat before next time
live_loop :metronome do
  sample :elec_blip, amp: 0.1   # amp means loudness, smaller = quieter
  sleep 1                       # sleep basically pauses, here 1 beat
end

in_thread do
  # sleep here just give a tiny delay, so tick starts first
  sleep 0.5

  # sample plays a sound file
  # here we give it the path variable
  # amp is volume, rate is speed+pitch (1.0 = normal, smaller slower lower pitch)
  sample valleyGuzheng, amp: 0.9, rate: 1.0

  # if nothing happens here… prob your path wrong or file name wrong or no wav
  # or your speaker is muted. check those.
end
