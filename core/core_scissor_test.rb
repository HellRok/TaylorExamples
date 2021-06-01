# Adapted from https://github.com/raysan5/raylib/blob/master/examples/core/core_scissor_test.c

screen_width = 800
screen_height = 450

init_window(screen_width, screen_height, "raylib [core] example - scissor test")

scissor_area = Rectangle.new(0, 0, 300, 300)
scissor_mode = true;

set_target_fps(60) # Set our game to run at 60 frames-per-second

# Main game loop
until window_should_close? # Detect window close button or ESC key
  # Update
  scissor_mode = !scissor_mode if is_key_pressed?(KEY_S)

  # Centre the scissor area around the mouse position
  scissor_area.x = get_mouse_x - scissor_area.width / 2
  scissor_area.y = get_mouse_y - scissor_area.height / 2

  # Draw
  begin_drawing

  clear_background(RAYWHITE)

  begin_scissor_mode(scissor_area.x, scissor_area.y, scissor_area.width, scissor_area.height) if scissor_mode

  # Draw full screen rectangle and some text
  # NOTE: Only part defined by scissor area will be rendered
  draw_rectangle(0, 0, get_screen_width, get_screen_height, RED)
  draw_text("Move the mouse around to reveal this text!", 190, 200, 20, LIGHTGRAY)

  end_scissor_mode if (scissor_mode)

  draw_rectangle_lines_ex(scissor_area, 1, BLACK)
  draw_text("Press S to toggle scissor test", 10, 10, 20, BLACK)

  end_drawing
end

# De-Initialization
close_window # Close window and OpenGL context
