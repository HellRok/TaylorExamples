# Adapted from https://github.com/raysan5/raylib/blob/master/examples/textures/textures_srcrec_dstrec.c

# Initialization
screen_width = 800
screen_height = 450

init_window(screen_width, screen_height, "raylib [textures] examples - texture source and destination rectangles")

# NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

scarfy = load_texture("resources/scarfy.png")

frame_width = scarfy.width / 6
frame_height = scarfy.height

# Source rectangle (part of the texture to use for drawing)
source = Rectangle.new(0.0, 0.0, frame_width, frame_height)

# Destination rectangle (screen rectangle where drawing part of texture)
destination = Rectangle.new(
  screen_width / 2.0, screen_height / 2.0, frame_width * 2.0, frame_height * 2.0
)

# Origin of the texture (rotation/scale point), it's relative to destination rectangle size
origin = Vector2.new(frame_width, frame_height)

rotation = 0

set_target_fps(60)

# Main game loop
until window_should_close? # Detect window close button or ESC key
  # Update
  rotation += 1

  # Draw
  begin_drawing

  clear_background(RAYWHITE)

  # NOTE: Using draw_texture_pro() we can easily rotate and scale the part of the texture we draw
  # source defines the part of the texture we use for drawing
  # destination defines the rectangle where our texture part will fit (scaling it to fit)
  # origin defines the point of the texture used as reference for rotation and scaling
  # rotation defines the texture rotation (using origin as rotation point)
  draw_texture_pro(scarfy, source, destination, origin, rotation, WHITE)

  draw_line(destination.x, 0, destination.x, screen_height, GRAY)
  draw_line(0, destination.y, screen_width, destination.y, GRAY)

  draw_text("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, GRAY)

  end_drawing
end

# De-Initialization
unload_texture(scarfy) # Texture unloading

close_window # Close window and OpenGL context
