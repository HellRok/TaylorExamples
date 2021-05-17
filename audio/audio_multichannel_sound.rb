#!/usr/bin/env taylor
# Adapted from https://github.com/raysan5/raylib/blob/master/examples/audio/audio_multichannel_sound.c

# Initialization
screen_width = 800
screen_height = 450

init_window(screen_width, screen_height, "raylib [audio] example - Multichannel sound playing")

init_audio_device # Initialize audio device

wav = load_sound("resources/sound.wav") # Load WAV audio file
ogg = load_sound("resources/target.ogg") # Load OGG audio file

set_sound_volume(wav, 0.2)

set_target_fps(60) # Set our game to run at 60 frames-per-second

# loop
until window_should_close? # Detect window close button or ESC key
  # Update
  play_sound_multi(wav) if (is_key_pressed(KEY_ENTER)) # Play a new wav sound instance
  play_sound_multi(ogg) if (is_key_pressed(KEY_SPACE)) # Play a new ogg sound instance

  # Draw
  begin_drawing()

  clear_background(RAYWHITE)

  draw_text("MULTICHANNEL SOUND PLAYING", 20, 20, 20, GRAY)
  draw_text("Press SPACE to play new ogg instance!", 200, 120, 20, LIGHTGRAY)
  draw_text("Press ENTER to play new wav instance!", 200, 180, 20, LIGHTGRAY)

  draw_text("CONCURRENT SOUNDS PLAYING: #{get_sounds_playing()}", 220, 280, 20, RED)

  end_drawing
end

# De-Initialization
stop_sound_multi # We must stop the buffer pool before unloading

unload_sound(wav) # Unload sound data
unload_sound(ogg) # Unload sound data

close_audio_device # Close audio device

close_window # Close window and OpenGL context
