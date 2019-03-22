extends Node2D

const Main = preload("res://Scripts/main.gd")
const BoardData = preload("res://Scripts/BoardData.gd")
const PlayerEntry = preload("res://Scripts/PlayerEntry.gd")
const MessageDialog = preload("res://Scripts/MessageDialog.gd")

onready var main = get_node("/root/Main")

onready var pinkPlayer : PlayerEntry = get_node("VBoxContainer/PinkPlayer")
onready var yellowPlayer : PlayerEntry = get_node("VBoxContainer/YellowPlayer")
onready var bluePlayer : PlayerEntry = get_node("VBoxContainer/BluePlayer")
onready var greenPlayer : PlayerEntry = get_node("VBoxContainer/GreenPlayer")

onready var messageDialog : MessageDialog = get_node("/root/Main/MessageDialog")

func _on_ExitButton_pressed():
	messageDialog.showMessageDialog(main, "Exit Game?", "Exit this game?", "Yes", "exitGame", "No", "")

func _on_AboutButton_pressed():
	main.showNode(main.aboutScene)


func _on_StartButton_pressed():
	main.changeState(Main.GameState.START)

func setPlayerName(player : int, playerName : String):
	match player:
		BoardData.PenType.PINK:
			return pinkPlayer.setName(playerName)
		BoardData.PenType.YELLOW:
			return yellowPlayer.setName(playerName)
		BoardData.PenType.BLUE:
			return bluePlayer.setName(playerName)
		BoardData.PenType.GREEN:
			return greenPlayer.setName(playerName)


func getPlayerName(player : int):
	match player:
		BoardData.PenType.PINK:
			return pinkPlayer.getName()
		BoardData.PenType.YELLOW:
			return yellowPlayer.getName()
		BoardData.PenType.BLUE:
			return bluePlayer.getName()
		BoardData.PenType.GREEN:
			return greenPlayer.getName()


func getPlayerEnabled(player : int):
	match player:
		BoardData.PenType.PINK:
			return pinkPlayer.isPlayerEnabled()
		BoardData.PenType.YELLOW:
			return yellowPlayer.isPlayerEnabled()
		BoardData.PenType.BLUE:
			return bluePlayer.isPlayerEnabled()
		BoardData.PenType.GREEN:
			return greenPlayer.isPlayerEnabled()


func setPlayerEnabled(player : int, enabled : bool):
	match player:
		BoardData.PenType.PINK:
			return pinkPlayer.setChecked(enabled)
		BoardData.PenType.YELLOW:
			return yellowPlayer.setChecked(enabled)
		BoardData.PenType.BLUE:
			return bluePlayer.setChecked(enabled)
		BoardData.PenType.GREEN:
			return greenPlayer.setChecked(enabled)
