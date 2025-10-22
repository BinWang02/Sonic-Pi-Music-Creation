# My idea is to mix a traditional Chinese sound, the guzheng, with some modern drums.

# I learned how to use my own samples from the tutorial!
# Link : https://sonic-pi.net/tutorial.html#section-3-1
bowedGuzheng  = "/Users/BingWang/Desktop/A2/music/Sonic-Pi-Music-Creation/samples/wave/lovely-chinese-guzheng-bowed-16700.wav"
# And this is the main melody guzheng sample. It's much clearer.
soloGuzheng   = "/Users/BingWang/Desktop/A2/music/Sonic-Pi-Music-Creation/samples/wave/guzheng-solo-22676.wav"

# I want a slow and chill song, so I set the beats per minute (BPM) to 55.
use_bpm 55

# This is a counter for my drum pattern later. I start it at 0.
set :bar_count, 0
# This is the most important thing I learned! It's like a signal for which part of the song to play.
# This idea of using 'set' and 'get' to control loops is called State. It was confusing but so useful.
# I learned it from here: https://sonic-pi.net/tutorial.html#section-10-1
set :section, :bow

# This loop is like the director of my whole song. It doesn't make sound itself.
# Live loops are the heart of Sonic Pi, they just run forever.
# Tutorial for live loops : https://sonic-pi.net/tutorial.html#section-5
live_loop :arrangement do
  # The song starts with the :bow section, for 5 seconds.
  set :section, :bow
  sleep 5
  
  # Then a small drum fill for 2 seconds to build up.
  set :section, :soft_fill
  sleep 2
  
  # Another, more powerful drum fill for 2 seconds.
  set :section, :punch_fill
  sleep 2
  
  # This is the main part of the song, it's pretty long.
  set :section, :mix_a
  sleep 51  # This makes the total song about 60 seconds long.
  
  # After the main part, I send the ':end' signal.
  set :section, :end
  # The director's job is done, so this loop can stop.
  stop
end

# This loop plays the soft guzheng at the very beginning.
live_loop :bow_intro do
  # All my loops check for this signal. If it's the end, they stop.
  if get(:section) == :end
    stop
  end
  # This loop will only play if the director says it's the ':bow' section.
  # After this section, this loop's job is done so it stops.
  if get(:section) != :bow
    stop
  end
  # I use 'finish:0.05' to play only a tiny piece of the sound. It's a nice effect.
  # Otherwise the song is too long for 10min
  sample bowedGuzheng, amp: 0.9, finish:0.05
  sleep 5
end

# This is the first drum fill, a simple and soft one.
live_loop :soft_fill do
  # First, check if the song is over.
  if get(:section) == :end
    stop
  end
  # This part is a trick I learned. If it's not this loop's turn to play...
  # ...it will just sleep for a bit and check again. This saves computer power.
  if get(:section) != :soft_fill
    sleep 1
    next
  end
  # This means "do the following 4 times".
  4.times do
    # A simple kick and cymbal beat.
    sample :bd_haus, amp: 0.9
    sleep 0.5
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.5
  end
end

# This second drum fill is faster and has more punch.
live_loop :punch_fill do
  # Always check if we need to stop.
  if get(:section) == :end
    stop
  end
  # Waiting for its turn to play, just like the other loop.
  if get(:section) != :punch_fill
    sleep 1
    next
  end
  # A faster pattern, sleeping only 0.25.
  6.times do
    sample :bd_haus, amp: 1
    sample :drum_cymbal_closed, amp: 0.7
    sleep 0.25
  end
  # Adding a snare drum ('sn_dolf') for more energy.
  2.times do
    sample :sn_dolf, amp: 1.1
    sample :drum_cymbal_closed, amp: 0.8
    sleep 0.25
  end
end

# This is my main drum pattern. It's the most complex part I wrote.
live_loop :drum_a do
  # Check for the end signal from the director loop.
  if get(:section) == :end
    stop
  end
  # This drum beat only plays during the main ':mix_a' section.
  if get(:section) != :mix_a
    sleep 1
    next
  end
  
  # This math '%' trick was hard to understand, but it's very cool.
  # It lets me create an 8-bar pattern that repeats. 'bar' will always be a number from 0 to 7.
  bar = get(:bar_count) % 8
  
  # For the first 2 bars (bar 0 and 1), I keep the pattern very simple.
  # I only use the kick drum sound (:bd_haus).
  # I want this to sound like a calm intro before the beat builds up.
  if bar < 2
    sample :bd_haus    # play the bass drum sound once
    sleep 1   # wait for 1 beat, this gives space between hits
    sleep 1   # wait another 1 beat, so total 2 beats of silence before next kick
    sample :bd_haus   # play the bass drum again
    sleep 1   # another beat of space
    sleep 1   # final beat to complete the 4-beat pattern
  # For the next 2 bars (2, 3), I add a snare drum.
  elsif bar < 4
    sample :bd_haus    # kick drum to start the bar
    sleep 0.5   # short wait between kick and hat
    # play closed hi-hat quietly (amp 0.6)
    # amp means volume
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.5   # complete the first beat
    # snare drum hit on beat 2
    sample :sn_dolf
    sleep 1     # full beat for the snare
    # repeat kick, hat, snare again for the second half of this bar
    sample :bd_haus
    sleep 0.5   # same timing as before
    sample :drum_cymbal_closed, amp: 0.6
    sleep 0.5   # complete the third beat
    sample :sn_dolf
    sleep 1     # final beat of the bar
  # For bars 4 and 5, the pattern gets faster and more busy.
  # I make everything faster: shorter sleep times and more hi-hats.
  elsif bar < 6
    sample :bd_haus   # kick drum starts the faster pattern
    # shorter sleep than before (0.25) makes the beat tighter
    sleep 0.25
    # hi-hat with slightly louder volume (0.7)
    sample :drum_cymbal_closed, amp: 0.7
    sleep 0.25        # quick timing for tighter feel
    # snare hit to keep the rhythm strong
    sample :sn_dolf
    # repeat the same pattern again
    sleep 0.5         # half beat before repeating
    sample :bd_haus   # second kick in the pattern
    sleep 0.25        # same tight timing
    sample :drum_cymbal_closed, amp: 0.7
    sleep 0.25        # complete the pattern
    sample :sn_dolf   # second snare hit
    sleep 0.5         # prepare for the fast hi-hats
    # This creates a fast hi-hat roll for excitement
    8.times do
      sample :drum_cymbal_closed, amp: 0.5  # quieter hi-hats for the roll
      sleep 0.125   # very fast timing creates the rolling effect
    end
  # For the last 2 bars (6, 7), it's the most energetic part to lead back to the beginning of the pattern.
  else
    # The climax pattern: kick and snare together for maximum energy
    2.times do
      sample :bd_haus, amp: 1    # full volume kick
      sample :sn_dolf, amp: 1     # full volume snare at the same time
      sleep 0.25                  # quick timing
      sample :drum_cymbal_closed, amp: 0.7  # hi-hat to fill
      sleep 0.25                  # complete the beat
    end
    # Fast hi-hats for a rolling effect
    8.times do
      sample :drum_cymbal_closed, amp: 0.5  # quieter for texture
      sleep 0.125                 # very fast roll
    end
    # Final powerful snare hits to end the pattern
    2.times do
      sample :sn_dolf, amp: 1.1   # extra loud for impact
      sleep 0.25                  # quick succession
    end
  end
  
  # This is VERY important! I have to increase the counter each time.
  # I forgot this at first and my drum pattern never changed! It was stuck on bar 0.
  set :bar_count, get(:bar_count) + 1
end

# This loop plays the main guzheng melody.
live_loop :guzheng_a do
  # Check if the song has ended.
  if get(:section) == :end
    stop
  end
  # It should only play during the ':mix_a' part.
  if get(:section) != :mix_a
    sleep 1
    next
  end
  
  # Play the guzheng sample one time.
  # I cut it a little short with 'finish:0.3' so it fits better.
  sample soloGuzheng, amp: 0.9, rate: 1.0, finish:0.3
  # The sample is long, so I wait 30 seconds before playing it again.
  sleep 30
  
  # I play it a second time to fill the main part of the song.
  # I add this check in case the song ends while it was sleeping for 30s.
  # I had to set finish 0.3 to make it fit well in the 30s gap.
  if get(:section) != :end
    sample soloGuzheng, amp: 0.9, rate: 1.0, finish:0.3
  end
end

# This is a safety timer. I saw this trick for using 'in_thread' in an example.
# 'in_thread' means this code runs at the same time as everything else.
# Link for threads : https://sonic-pi.net/tutorial.html#section-8-1
in_thread do
  # It just waits for 60 seconds...
  sleep 60
  # ...and then it forces the song to end. This is a backup just in case something goes wrong.
  set :section, :end
end