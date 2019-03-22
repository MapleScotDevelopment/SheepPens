extends Label

const TWEEN_TIME = 0.2

const SMALL_X = 1500
const SMALL_Y = 0
const SMALL_SCALE = 1.3

const BIG_X = 850
const BIG_Y = 200
const BIG_SCALE = 4

onready var tween = get_node("Tween")

func zoom(big : bool):
	if big:
		tween.interpolate_method(self, "set_position", self.get_position(),
			Vector2(BIG_X, BIG_Y), TWEEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_method(self, "set_scale", self.get_scale(),
			Vector2(BIG_SCALE, BIG_SCALE), TWEEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_method(self, "set_position", self.get_position(),
			Vector2(SMALL_X, SMALL_Y), TWEEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_method(self, "set_scale", self.get_scale(),
			Vector2(SMALL_SCALE, SMALL_SCALE), TWEEN_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
