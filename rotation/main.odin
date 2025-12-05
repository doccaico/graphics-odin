// A modded version: https://github.com/dabzr/Circle-Rotation

package main

import "core:math"
import rl "vendor:raylib"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
FPS :: 60
CLEAR_COLOR :: rl.RAYWHITE

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rotation")
	defer rl.CloseWindow()

	rl.SetTargetFPS(FPS)

	radius :f32 = 150.0
	degree :f32 = 270.0
	speed :f32 = 4.0

	for !rl.WindowShouldClose() {
		//
		// Update
		//

		x :f32 = SCREEN_WIDTH / 2 + radius * math.cos_f32(degree * rl.DEG2RAD)
		y :f32 = SCREEN_HEIGHT / 2 + radius * math.sin_f32(degree * rl.DEG2RAD)
		speed += rl.GetMouseWheelMove()
		degree = 0.0 if degree >= 360.0 else degree + speed

		//
		// Render
		//

		rl.BeginDrawing()
		rl.ClearBackground(CLEAR_COLOR)

		rl.DrawLine(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2, rl.RED)
		rl.DrawLine(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT, rl.RED)
		rl.DrawCircle(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 15, rl.BLACK)
		rl.DrawCircle(i32(x), i32(y), 20, rl.BLUE)
		rl.DrawText("Scroll the mouse to change the speed", 200, 0, 20, rl.BLACK)

		rl.EndDrawing()
	}
}
