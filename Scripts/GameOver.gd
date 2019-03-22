extends Node2D

const BoardData = preload("res://Scripts/BoardData.gd")
const Main = preload("res://Scripts/main.gd")

const IMAGE_POSITION_x = 474

onready var main = get_node("/root/Main")
onready var playerImage : TextureRect = get_node("PlayerImage")
onready var playerName : Label = get_node("PlayerName")
onready var cheerSound : AudioStreamPlayer = get_node("cheerSound")

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
	cheerSound.play()


func _on_MenuButton_pressed():
	main.changeState(Main.GameState.MENU)
