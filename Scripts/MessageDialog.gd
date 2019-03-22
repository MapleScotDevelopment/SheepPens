extends Control

const CONFIRM_X = 1350
const CONFIRM_SHOW_Y = 750
const CONFIRM_HIDE_Y = -1000

onready var title : Label = get_node("Title")
onready var message : Label = get_node("Message")
onready var acceptLabel : Label = get_node("AcceptButton/Label")
onready var declineLabel : Label = get_node("DeclineButton/Label")
onready var declineButton : Button = get_node("DeclineButton")

onready var tween : Tween = get_node("Tween")

var caller
var acceptCallback : String
var declineCallback : String

var hasDecline = true

func _ready():
	set_visible(false)
	set_position(Vector2(CONFIRM_X, CONFIRM_HIDE_Y))

func _unhandled_key_input(event : InputEventKey):
	if !event.is_pressed():
		if is_visible():
			if event.scancode == KEY_ESCAPE || event.scancode == KEY_BACK:
				get_tree().set_input_as_handled()
				if hasDecline:
					_on_DeclineButton_pressed()
				else:
					_on_AcceptButton_pressed()
			if event.scancode == KEY_ENTER:
				_on_AcceptButton_pressed()

func showMessageDialog(caller, title, message, acceptLabel, acceptCallback, declineLabel=null, declineCallback=null):
	self.caller = caller
	var translation = tr(title)
	if translation != null:
		title = translation
	self.title.set_text(title)
	translation = tr(message)
	if translation != null:
		message = translation
	self.message.set_text(message)
	self.acceptLabel.set_text(acceptLabel)
	self.acceptCallback = acceptCallback
	
	if declineLabel != null:
		hasDecline = true
		self.declineButton.set_visible(true)
		self.declineLabel.set_text(declineLabel)
		self.declineCallback = declineCallback
	else:
		hasDecline = false
		self.declineButton.set_visible(false)
	
	showDialog()


func showDialog():
	set_visible(true)
	tween.interpolate_method(self, "set_position", Vector2(CONFIRM_X, CONFIRM_HIDE_Y),
		Vector2(CONFIRM_X, CONFIRM_SHOW_Y), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()


func hideDialog():
	tween.interpolate_method(self, "set_position", Vector2(CONFIRM_X, CONFIRM_SHOW_Y),
		Vector2(CONFIRM_X, CONFIRM_HIDE_Y), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	set_visible(false)


func _on_AcceptButton_pressed() -> void:
	hideDialog()
	caller.call(acceptCallback)


func _on_DeclineButton_pressed() -> void:
	hideDialog()
	if !declineCallback.empty():
		caller.call(declineCallback)

