extends Node2D

const Main = preload("res://Scripts/main.gd")

onready var main = get_node("/root/Main")
onready var aboutTextLabel = get_node("RichTextLabel")

var app_url = "http://maplescot.itch.io/sheep-pens/"

func _ready():
	if OS.get_name() == "Android":
		app_url = "https://play.google.com/store/apps/details?id=com.maple.scot.sheeppens"
	if OS.get_name() == "iOS":
		app_url = ""
		
	var aboutText = tr("AboutText")
	if aboutText != null:
		aboutTextLabel.parse_bbcode(aboutText)

func _on_OkButton_pressed() -> void:
	main.hideNode(main.aboutScene)



func _on_RateButton_pressed() -> void:
	OS.shell_open(app_url)


func _on_RichTextLabel_meta_clicked(meta) -> void:
	OS.shell_open(meta)
