extends AnimatedSprite

const START_X = 4400
const END_X = -600

const Main = preload("res://Scripts/main.gd")

onready var main = get_node("/root/Main")
onready var bleat : AudioStreamPlayer = get_node("bleat")

onready var tween : Tween = get_node("Tween")

func startBadSheep():
	play()
	tween.interpolate_method(self, "set_position", get_position(), Vector2(END_X, position.y),
		1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	bleat.play()
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_method(self, "set_position", get_position(), Vector2(START_X, position.y),
		0.001, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	stop()
	tween.interpolate_callback(main, 0.02, "changeState", Main.GameState.SPIN)
	tween.start()
	bleat.stop()
