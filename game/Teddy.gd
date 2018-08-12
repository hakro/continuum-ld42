extends AnimatedSprite

var speed = 100
var health = 100
var time_elapsed = 0
var initial_position_y

var speech = [
	{"sentence": "Hello there!\nHow are you?", "duration": 2},
	{"sentence": "I'm Teddy, from the planet Zhar", "duration": 3},
	{"sentence": "Sorry I can't talk. The idiot who put me in this simulation didn't give me a voice", "duration": 6},
	{"sentence": "I was on my way to my cousin's birthday, but somehow I got stuck here ...", "duration": 6},
	{"sentence": "It seems to be a glitch in the SpaceTime Continuum", "duration": 5},
	{"sentence": "I'm now trapped here and I need you help to escape", "duration": 4},
	{"sentence": "All you have to do is fix the glitch before the space collapses on me", "duration": 7},
	{"sentence": "You just have to follow the patterns with your keyboard Arrows", "duration": 5},
	{"sentence": "You can Start when you want on the right", "duration": 5}
]

var sentence_number = 0

func _ready():
	initial_position_y = position.y
	$DeathTween.interpolate_property(self, "scale", scale, Vector2(0, 0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _process(delta):
	if health > 50:
		happy()
	if health < 60:
		sad()
	if health <= 0:
		health = 0
		dead()
		
	if $DialogTimer.is_stopped() and sentence_number < speech.size():
		say(speech[sentence_number])
		sentence_number += 1
	
	# Fload Teddy up and down
	time_elapsed += delta
	position.y = initial_position_y + sin(time_elapsed * 4) * 8

func happy():
	if $AnimationTimer.is_stopped():
		play("happy")
		modulate = Color("ffffff")
		$AnimationTimer.start()

func sad():
	$AnimationTimer.stop()
	play("sad")
	modulate = Color("ffffff")
	$AnimationTimer.start()

func dead():
	play("dead")
	modulate = Color("f48b57")
	$DeathTween.start()
	$Dialog.hide()
	
func say(speech):
	$Dialog.show()
	$Dialog/Text.text = speech.sentence
	$DialogTimer.wait_time = speech.duration
	$DialogTimer.start()
	
# This callback is necessary to reset the animation
# The playing flag stays at true even if the animation finishes
# Godot 3 bug?
func _on_Teddy_animation_finished():
	playing = false
	frame = 0

# Must stop the timer
# Also a bug?
func _on_DialogTimer_timeout():
	$Dialog.hide()
	$DialogTimer.stop()