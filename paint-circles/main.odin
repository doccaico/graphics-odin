package main

import "core:container/queue"
import rl "vendor:raylib"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
FPS :: 60
CLEAR_COLOR :: rl.RAYWHITE
CIRCLE_QUEUE_LENGTH :: 70
CIRCLE_RADIUS_MIN :: 10
CIRCLE_RADIUS_MAX :: 40
PARTICLE_COUNT :: 300
PARTICLE_COLOR := rl.GRAY
PARTICLE_INITIAL_LIFE :: 30.0

Circle :: struct {
	pos: rl.Vector2,
	radius: f32,
	color: rl.Color,
}

Particle :: struct {
	pos: rl.Vector2,
	color: rl.Color,
	life: f32,
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "paint circles")
	defer rl.CloseWindow()

	rl.SetTargetFPS(FPS)

	circle_queue: queue.Queue(Circle)
	queue.init(&circle_queue, capacity = CIRCLE_QUEUE_LENGTH)
	defer queue.destroy(&circle_queue)

	particle_queue: queue.Queue(Particle)
	queue.init(&particle_queue)
	defer queue.destroy(&particle_queue)

	for !rl.WindowShouldClose() {

		if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
			cursor_pos  := rl.GetMousePosition()

			// circle
			radius := f32(rl.GetRandomValue(CIRCLE_RADIUS_MIN, CIRCLE_RADIUS_MAX))
			color := rl.Color{
				u8(rl.GetRandomValue(0, 255)),
				u8(rl.GetRandomValue(0, 255)),
				u8(rl.GetRandomValue(0, 255)),
				255,
			}
			queue.push_back(&circle_queue, Circle{cursor_pos, radius, color})

			// particle
			for i := 0; i < PARTICLE_COUNT; i += 1 {
				for {
					x_min := i32(cursor_pos.x - radius * 2.0)
					x_max := i32(cursor_pos.x + radius * 2.0)
					y_min := i32(cursor_pos.y - radius * 2.0)
					y_max := i32(cursor_pos.y + radius * 2.0)
					point := rl.Vector2{
						f32(rl.GetRandomValue(x_min, x_max)),
						f32(rl.GetRandomValue(y_min, y_max)),
					}
					if !rl.CheckCollisionPointCircle(point, cursor_pos, radius) &&
					rl.CheckCollisionPointCircle(point, cursor_pos, radius + 15.0) {
						particle := Particle{
							pos = point,
							color = PARTICLE_COLOR,
							life = PARTICLE_INITIAL_LIFE,
						}
						queue.push_back(&particle_queue, particle)
						break
					}
				}
			}
		}

		//
		// Update
		//

		// circle
		if queue.len(circle_queue) == CIRCLE_QUEUE_LENGTH {
			queue.pop_front(&circle_queue)
		}

		// particle
		for i := 0; i < queue.len(particle_queue); i += 1 {
			particle := queue.get(&particle_queue, i)
			if particle.life <= 0 {
				queue.pop_front(&particle_queue)
			}
		}

		// life
		for i := 0; i < queue.len(particle_queue); i += 1 {
			queue.get_ptr(&particle_queue, i).life -= 1
		}

		//
		// Render
		//

		rl.BeginDrawing()
		rl.ClearBackground(CLEAR_COLOR)

		// particle
		for i := 0; i < queue.len(particle_queue); i += 1 {
			particle := queue.get(&particle_queue, i)
			rl.DrawPixelV(particle.pos, particle.color)
		}

		// circle
		for i := 0; i < queue.len(circle_queue); i += 1 {
			circle := queue.get(&circle_queue, i)
			rl.DrawCircleV(circle.pos, circle.radius, circle.color)
		}

		rl.EndDrawing()
	}
}
