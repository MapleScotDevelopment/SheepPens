extends Node2D

export (StreamTexture) var playerImage

export (bool) var top
export (bool) var right
export (bool) var isBorg

var sheepImage : Sprite
var sheepName : Label
var sheepCount : Label

const COUNT_TOP_Y = 169
const NAME_TOP_Y = -175
const NAME_RIGHT_X = -700
const NAME_BORG_X = -270
const NAME_BORG_Y = 170

func _ready():
	sheepImage = get_node("SheepImage")
	sheepName = get_node("SheepName")
	sheepCount = get_node("SheepCount")
	sheepImage.set_texture(playerImage)
	
	if top:
		sheepCount.rect_position.y = COUNT_TOP_Y
		sheepName.rect_position.y = NAME_TOP_Y
	
	if right:
		sheepName.rect_position.x = NAME_RIGHT_X
		sheepName.set_align(Label.ALIGN_RIGHT)
	
	if isBorg:
		sheepName.set_align(Label.ALIGN_CENTER)
		sheepName.rect_position = Vector2(NAME_BORG_X, NAME_BORG_Y)
		if !right:
			sheepImage.flip_h = true


func setPlayerName(name : String):
	sheepName.set_text(name)


func setPlayerCount(count : int):
	var c = String(count)
	sheepCount.set_text(c)
