extends Node2D

var continuum_radius
var continuum_pressure
var player_ready = false

export (PackedScene) var Instruction
var instruction

func _process(delta):

	continuum_radius = $Continuum.get_radius()
	continuum_pressure = $Continuum.get_pressure()
	
	# Teddy's Health
	$Teddy.health = int(clamp(range_lerp(continuum_radius, 100, 500, 0, 100), 0, 100))
	$HUD/Health.text = "Health: %d" % $Teddy.health
	
	# Update the pressure inside the Black Hole
	$HUD/Pressure.text = "Pressure: %d %%" % continuum_pressure
	
	# Check if the game is over
	game_over($Teddy.health, continuum_pressure)
		
	if player_ready:
		play_sequence()
	
	if $GetReadyLabel.visible:
		$GetReadyLabel.text = "Get Ready : " + str(int($GetReadyTimer.time_left) + 1)

# Play a sequence of instructions that the player must follow
func play_sequence():
	if !instruction or instruction.is_queued_for_deletion():
		instruction = Instruction.instance()
		instruction.position = Vector2(420, 450)
		add_child(instruction)
		instruction.connect("correct_action", self, "_on_Instruction_correct_action")
		instruction.connect("incorrect_action", self, "_on_Instruction_incorrect_action")

func game_over(health, pressure):
	# Win
	if pressure <= 0:
		$WinSound.play()
		$BackgroundMusic.stop()
		$MessageLabel.show()
		$MessageLabel.text = "You Won!\nTeddy can go back to his family\nSpaceBar to restart"
		player_ready = false
		$Continuum.set_physics_process(false)
		set_process(false)
	
	# Lose 
	if health <= 0:
		$LoseSound.play()
		$BackgroundMusic.stop()
		$MessageLabel.show()
		$MessageLabel.text = "You Lost!\nTeddy was swallowed by the Black Hole!\nSpaceBar to restart"
		player_ready = false
		set_process(false)

func _on_GetReadyTimer_timeout():
	player_ready = true
	$GetReadyLabel.hide()
	$Continuum.set_physics_process(true)

func _on_HUD_start_game():
	$GetReadyTimer.start()
	$StartSound.play()
	$GetReadyLabel.show()
	$HUD/Health.show()
	$HUD/Pressure.show()
	
func _on_Instruction_correct_action():
	# 0.03, very easy
	# 0.02 very hard
	$Continuum.grow(0.022)

func _on_Instruction_incorrect_action():
	$Continuum.shrink(0.01)
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().reload_current_scene()