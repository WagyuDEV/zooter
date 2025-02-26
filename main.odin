#+feature dynamic-literals
package main

import "core:fmt"

import rl "vendor:raylib"

ASPECT_RATIO : f32 = 16/9

WINDOW_HEIGHT : i32 = 720
WINDOW_WIDTH : i32 = 1280

Camera := rl.Camera2D{
    offset = rl.Vector2{1280/2,720/2}, // the camera offset location is the top left of the screen
    target = rl.Vector2{0,0},
    rotation = 0,
    zoom = 1
}



Player :: struct{
    world_pos: rl.Vector2,
    camera: rl.Camera2D
}

Object :: struct{
    edges: []rl.Vector2,
    // texture
    color: rl.Color
}

World :: struct{
    objects: [dynamic]Object
}

main :: proc(){
    // Raylib Setup
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "zooter")
    defer rl.CloseWindow()
    
    rl.SetTraceLogLevel(rl.TraceLogLevel.ERROR)

    rl.SetTargetFPS(60)
    rl.SetExitKey(.ESCAPE)
        
    // Player Setup
    player := Player{
        world_pos = rl.Vector2{0, 0},
        camera = Camera
    }

    ex_obj := Object{edges = []rl.Vector2{rl.Vector2{0+1,0+1}, rl.Vector2{10+1,0+1}, rl.Vector2{10+1, 10+1}, rl.Vector2{0+1,10+1}}, color = rl.RED}
    ex_obj2 := Object{edges = []rl.Vector2{rl.Vector2{100,100}, rl.Vector2{10+100,100}, rl.Vector2{10+100, 10+100}, rl.Vector2{100,10+100}}, color = rl.PURPLE}


    world := World{
        objects = [dynamic]Object{ex_obj, ex_obj2}
    }
    for !rl.WindowShouldClose(){
        get_input(&player)
        // player.camera.target=player.world_pos
        rl.BeginDrawing()
            rl.BeginMode2D(player.camera)
                draw_environment(world)

                rl.DrawRectangle(0,0, 100, 100, rl.RED)
                rl.DrawText("(0,0)", 0, 0, 50, rl.BLUE)

                rl.DrawRectangle(100,100, 100, 100, rl.RED)
                rl.DrawText("(100,100)", 100, 100, 50, rl.BLUE)
                middle := to_screen_coord(rl.Vector2{f32(1280/2),f32(720/2)}, player.camera)
                rl.DrawText("Center", i32(middle.x), i32(middle.y), 50, rl.BLUE)
                draw_player(player)
                rl.ClearBackground(rl.BROWN)
            rl.EndMode2D()
        rl.EndDrawing()
        fmt.println(player)
    }
    
}

to_screen_coord :: proc(coord: rl.Vector2, cam: rl.Camera2D) -> rl.Vector2{
    return coord-cam.offset
}

get_input :: proc(player: ^Player){
    if rl.IsKeyDown(.W){
        player.camera.offset.y+=10
        player.world_pos.y -= 10
    }
    if rl.IsKeyDown(.S){
        player.camera.offset.y-=10
        player.world_pos.y += 10
    }
    if rl.IsKeyDown(.A){
        player.camera.offset.x+=10
        player.world_pos.x -= 10
    }
    if rl.IsKeyDown(.D){
        player.camera.offset.x-=10
        player.world_pos.x += 10
    }
}

draw_player :: proc(player: Player){
    rl.DrawRectangle(i32(player.world_pos.x)-25, i32(player.world_pos.y)-25, 50, 50, rl.PURPLE)
}

draw_environment :: proc(env: World){
    for e in env.objects{
        v1 : rl.Vector2 // first edge
        vp : rl.Vector2 // previous edge
        for edge, i in e.edges{
            if i == 0{
                v1 = edge
            } else {
                rl.DrawLine(i32(vp.x), i32(vp.y), i32(edge.x), i32(edge.y), e.color) // previous edge -> current edge
            }
            if i == len(e.edges)-1{ 
                rl.DrawLine(i32(edge.x), i32(edge.y), i32(v1.x), i32(v1.y), e.color) // last edge -> first edge
            }
            vp = edge
        }
    }
}