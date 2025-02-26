package tinylib

import rl "vendor:raylib"

raylib_camera := rl.Camera2D{
    offset = rl.Vector2{1280/2,720/2}, // the camera offset location is the top left of the screen
    target = rl.Vector2{0,0},
    rotation = 0,
    zoom = 1
}

tiny_camera :: struct{
    position: rl.Vector2
}