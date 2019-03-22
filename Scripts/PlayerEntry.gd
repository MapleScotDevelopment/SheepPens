extends Node2D

export (StreamTexture) var playerImage

onready var image : TextureRect = get_node("Panel/PlayerImage")
onready var checkbox : CheckBox = get_node("Panel/CheckBox")
onready var textEdit : LineEdit = get_node("Panel/LineEdit")

func _ready():
	image.texture = playerImage


func setChecked(set : bool):
	checkbox.set_pressed(set)

func isPlayerEnabled() -> bool :
	return checkbox.is_pressed()


func setName(name : String):
	textEdit.set_text(name)

func getName() -> String :
	return textEdit.get_text()


func _on_LineEdit_text_entered(new_text : String):
	if !new_text.empty():
		setChecked(true)


func _on_LineEdit_focus_exited():
	if !textEdit.get_text().empty():
		setChecked(true)
