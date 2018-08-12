extends Node2D

var directions = ["right", "down", "left", "up"]
var direction
var timer_duration = 0.7

signal correct_action
signal incorrect_action

func _ready():
	randomize()
	$ActionTimer.wait_time = timer_duration
	$ActionTimer.start()
	var random_index = randi() % directions.size()
	direction = directions[random_index]
	$Sprite.rotation = random_index * PI / 2
	
	$FinalTween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(1.5, 1.5),
	                                 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$FinalTween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(1, 1 , 1, 0),
	                                 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _input(event):
	var correct_action = "ui_" + direction
	if event.is_action_pressed(correct_action) and not event.is_echo() and not $ActionTimer.is_stopped():
		win()
	else:
		for action in directions:
			if event.is_action_pressed("ui_" + action):
				lose()

func win():
	emit_signal("correct_action")
	# Disable the _input function and play the Tween
	$FinalTween.start()
	set_process_input(false)
	
func lose():
	emit_signal("incorrect_action")
	# Disable the _input function and play the Tween
	$FinalTween.start()
	$MissAudio.play()
	set_process_input(false)

func _on_ActionTimer_timeout():
	lose()

func _on_FinalTween_tween_completed(object, key):
	queue_free()
