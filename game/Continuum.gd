extends Node2D

var death_radius = 50
var survive_radius = 800

var shrink_speed = 0.0005
var shrinking = false

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if shrinking:
		shrink(shrink_speed)
		update_opacity()
	
func get_radius():
	return $Sprite.texture.get_size().x / 2 * $Sprite.scale.x

func shrink(rate):
	if get_radius() > death_radius:
		$Sprite.scale -= Vector2(rate, rate)
		
func grow(rate):
	$Sprite.scale += Vector2(rate, rate)

func _on_HUD_start_game():
	shrinking = true
	
func get_pressure():
	return int(clamp(range_lerp(get_radius(), 
	                 death_radius, survive_radius, 100, 0), 0, 100))

func update_opacity():
	var opacity = range_lerp(get_radius(), 250, 500, 1, 0)
	$Sprite.modulate = Color(0, 0, 0, opacity)