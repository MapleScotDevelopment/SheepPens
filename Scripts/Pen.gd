extends Sprite

const BoardData = preload("res://Scripts/BoardData.gd")

var pinkSheep : StreamTexture = load("res://Assets/Images/MinPinkSheep.png")
var yellowSheep : StreamTexture = load("res://Assets/Images/MinYellowSheep.png")
var blueSheep : StreamTexture = load("res://Assets/Images/MinBlueSheep.png")
var greenSheep : StreamTexture = load("res://Assets/Images/MinGreenSheep.png")
var borgSheep : StreamTexture = load("res://Assets/Images/MinBorgSheep.png")

onready var particles : Particles2D = get_node("Particles2D")
onready var baaSound : AudioStreamPlayer = get_node("BaaSound")

var pink_gradient = load("res://Assets/gradients/pink_gradienttexture.tres")
var yellow_gradient = load("res://Assets/gradients/yellow_gradienttexture.tres")
var blue_gradient = load("res://Assets/gradients/blue_gradienttexture.tres")
var green_gradient = load("res://Assets/gradients/green_gradienttexture.tres")
var black_gradient = load("res://Assets/gradients/black_gradienttexture.tres")


func setPen(penType):
	var playSound = true
	var process_material : ParticlesMaterial = particles.get_process_material()
	flip_h = false
	# can't use match with an int on an enum it doesn't work
	if penType == BoardData.PenType.PINK:
			visible = true
			texture = pinkSheep
			process_material.set_color_ramp(pink_gradient)
		
	elif penType == BoardData.PenType.YELLOW:
			visible = true
			texture = yellowSheep
			process_material.set_color_ramp(yellow_gradient)
			
	elif penType == BoardData.PenType.BLUE:
			visible = true
			texture = blueSheep
			process_material.set_color_ramp(blue_gradient)
		
	elif penType == BoardData.PenType.GREEN:
			visible = true
			texture = greenSheep
			process_material.set_color_ramp(green_gradient)
		
	elif penType == BoardData.PenType.COMPUTER1:
			visible = true
			texture = borgSheep
			process_material.set_color_ramp(black_gradient)
		
	elif penType == BoardData.PenType.COMPUTER2:
			visible = true
			texture = borgSheep
			process_material.set_color_ramp(black_gradient)
			flip_h = true
		
	elif penType == BoardData.PenType.NONE:
			visible = false
			playSound = false
	
	particles.set_emitting(true)
	if playSound:
		baaSound.play()

