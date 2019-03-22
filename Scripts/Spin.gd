extends Node2D

const BoardData = preload("res://Scripts/BoardData.gd")
const Main = preload("res://Scripts/main.gd")
const MessageDialog = preload("res://Scripts/MessageDialog.gd")

const SINGLE_FENCE_START_ANGLE : float = 2.0
const SINGLE_FENCE_END_ANGLE : float = 178.0

const DOUBLE_FENCE_START_ANGLE : float = 182.0
const DOUBLE_FENCE_END_ANGLE : float = 268.0

const BAD_PIGGY_START_ANGLE : float = 272.0
const BAD_PIGGY_END_ANGLE : float = 358.0

const IMAGE_POSITION_x = 474

onready var main = get_node("/root/Main")

onready var playerImage : TextureRect = get_node("PlayerImage")
onready var playerName : Label = get_node("PlayerName")
onready var arrow : Sprite = get_node("Spinner/Arrow")
onready var tween : Tween = get_node("Tween")
onready var spinStart : AudioStreamPlayer = get_node("spinStart")
onready var spin : AudioStreamPlayer = get_node("spin")
onready var spinStop : AudioStreamPlayer = get_node("spinStop")

onready var messageDialog : MessageDialog = get_node("/root/Main/MessageDialog")

var spinning : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func setPlayer(player, playerName : String):
	playerImage.rect_position.x = IMAGE_POSITION_x
	playerImage.rect_scale.x = 1
	match player:
		BoardData.PenType.PINK:
			playerImage.texture = load("res://Assets/Images/MinPinkSheep.png")
		BoardData.PenType.YELLOW:
			playerImage.texture = load("res://Assets/Images/MinYellowSheep.png")
		BoardData.PenType.BLUE:
			playerImage.texture = load("res://Assets/Images/MinBlueSheep.png")
		BoardData.PenType.GREEN:
			playerImage.texture = load("res://Assets/Images/MinGreenSheep.png")
		BoardData.PenType.COMPUTER1:
			playerImage.texture = load("res://Assets/Images/MinBorgSheep.png")
		BoardData.PenType.COMPUTER2:
			playerImage.texture = load("res://Assets/Images/MinBorgSheep.png")
			playerImage.rect_position.x *= 2
			playerImage.rect_scale.x = -1
	
	self.playerName.set_text(playerName)


func _on_SpinButton_pressed():
	if spinning:
		return
	
	spinning = true
	var final : int = randi() % 4
	var result : int
	var finalAngle
	match(final):
		0, 1:
			result = Main.GameState.FENCE1
			finalAngle = rand_range(SINGLE_FENCE_START_ANGLE, SINGLE_FENCE_END_ANGLE)
		2:
			result = Main.GameState.BAD_SHEEP
			finalAngle = rand_range(BAD_PIGGY_START_ANGLE, BAD_PIGGY_END_ANGLE)
		3:
			result = Main.GameState.FENCE2
			finalAngle = rand_range(DOUBLE_FENCE_START_ANGLE, DOUBLE_FENCE_END_ANGLE)
	
	tween.interpolate_method(arrow, "set_rotation_degrees", arrow.get_rotation(), 360, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	spinStart.play()
	yield(tween, "tween_completed")
	tween.interpolate_method(arrow, "set_rotation_degrees", 0, 3600, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	spin.play()
	tween.start()
	yield(tween, "tween_completed")
	spin.stop()
	tween.interpolate_method(arrow, "set_rotation_degrees", 0, finalAngle, 0.25, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	spinStop.play()
	yield(tween, "tween_completed")
	tween.interpolate_callback(self, 0.3, "_on_spin_end", result)
	tween.start()
	yield(tween, "tween_completed")

func set_rotation_degrees(var newValue):
	arrow.set_rotation_degrees(newValue)

func _on_spin_end(result: int):
	spinning = false
	main.changeState(result)


func _on_ExitButton_pressed():
	messageDialog.showMessageDialog(self, "End Game?", "End this game and return to the menu?", "Yes", "endGame", "No", "")

func endGame():
	# clicked yes on message dialog to end the game
	main.changeState(Main.GameState.MENU)
