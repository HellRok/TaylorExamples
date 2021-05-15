#!/usr/bin/env taylor
# Adapted from https://github.com/raysan5/raylib/blob/master/examples/audio/audio_module_playing.c

MAX_CIRCLES = 64

class CircleWave
  attr_accessor :position, :radius, :alpha, :speed, :colour
  def initialize(position, radius, alpha, speed, colour)
    @position = position
    @radius = radius
    @alpha = alpha
    @speed = speed
    @colour = colour
  end
end

# Initialization
screen_width = 800
screen_height = 450

set_config_flags(FLAG_MSAA_4X_HINT) # NOTE: Try to enable MSAA 4X

init_window(screen_width, screen_height, "raylib [audio] example - module playing (streaming)")

init_audio_device # Initialize audio device

colours = [ORANGE, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK,
          YELLOW, GREEN, SKYBLUE, PURPLE, BEIGE]

# Create some circles for visual effect
circles = []

MAX_CIRCLES.times do
  radius = rand(30) + 10
  circles << CircleWave.new(
    Vector2.new(
      rand(screen_width - (radius * 2)) + radius,
      rand(screen_height - (radius * 2)) + radius,
    ),
    radius,
    0,
    rand(100) / 2000.0,
    colours.sample
  )
end

music = load_music_stream("resources/median_test.ogg")
music.looping = false
pitch = 1.0

play_music_stream(music)

time_played = 0.0
pause = false

set_target_fps(60) # Set our game to run at 60 frames-per-second

# Main game loop
until window_should_close? # Detect window close button or ESC key
  # Update
  update_music_stream(music) # Update music buffer with new stream data

  # Restart music playing (stop and play)
  if (is_key_pressed(KEY_SPACE))
    stop_music_stream(music)
    play_music_stream(music)
  end

  # Pause/Resume music playing
  if (is_key_pressed(KEY_P))
    pause = !pause

    if (pause)
      pause_music_stream(music)
    else
      resume_music_stream(music)
    end
  end

  if is_key_down(KEY_DOWN)
    pitch -= 0.01
  elsif is_key_down(KEY_UP)
    pitch += 0.01
  end

  set_music_pitch(music, pitch)

  # Get time_played scaled to bar dimensions
  time_played = get_music_time_played(music) / get_music_time_length(music) * (screen_width - 40)

  # Color circles animation
  circles.each { |circle|
    circle.alpha += circle.speed
    circle.radius += circle.speed * 10.0

    circle.speed *= -1 if (circle.alpha > 1.0)

    if (circle.alpha <= 0.0)
      circle.alpha = 0.0
      circle.radius = rand(30) + 10
      circle.position.x = rand(screen_width - (circle.radius * 2)) + circle.radius
      circle.position.y = rand(screen_height - (circle.radius * 2)) + circle.radius
      circle.colour = colours.sample
      circle.speed = rand(100) / 2000.0
    end
  }

  # Draw
  begin_drawing

  clear_background(RAYWHITE)

  circles.each { |circle|
    draw_circle_v(circle.position, circle.radius, fade(circle.colour, circle.alpha));
  }

  # Draw time bar
  draw_rectangle(20, screen_height - 20 - 12, screen_width - 40, 12, LIGHTGRAY);
  draw_rectangle(20, screen_height - 20 - 12, time_played, 12, MAROON);
  draw_rectangle_lines(20, screen_height - 20 - 12, screen_width - 40, 12, GRAY);

  end_drawing
end

# De-Initialization
unload_music_stream(music) # Unload music stream buffers from RAM

close_audio_device # Close audio device (music streaming is automatically stopped)

close_window # Close window and OpenGL context

