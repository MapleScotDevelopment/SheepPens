extends Node

const GameData = preload("res://Scripts/GameData.gd")
const BoardData = preload("res://Scripts/BoardData.gd")
const BoardPlayer = preload("res://Scripts/BoardPlayer.gd")
const Pen = preload("res://Scripts/Pen.gd")
const BorgSheep = preload("res://Scripts/BorgSheep.gd")
const TitleText = preload("res://Scripts/TitleText.gd")
#const BadSheep = preload("res://Scripts/BadSheep.gd")
const MessageDialog = preload("res://Scripts/MessageDialog.gd")

const SHOW_Y : int = -50
const HIDE_Y : int = 2000

var  SINGLE_FENCE_PROMPT : String = tr("SINGLE_FENCE_PROMPT") #"Choose where to put your fence"
var SECOND_FENCE_PROMPT : String = tr("SECOND_FENCE_PROMPT") #"Choose where to put your second fence";
var FENCE2_PROMPT : String = tr("FENCE2_PROMPT") #"Choose where to put your first fence"
var BAD_SHEEP_PROMPT : String = tr("BAD_SHEEP_PROMPT") #"The NAUGHTY SHEEP runs away - miss this turn"

enum GameState { MENU, START, SPIN, FENCE1, FENCE2, BAD_SHEEP, GAME_OVER }


onready var pinkPlayer : BoardPlayer = get_node("PinkPlayer")
onready var yellowPlayer : BoardPlayer = get_node("YellowPlayer")
onready var bluePlayer : BoardPlayer = get_node("BluePlayer")
onready var greenPlayer : BoardPlayer = get_node("GreenPlayer")
onready var borg1 : BoardPlayer = get_node("BorgPlayer1")
onready var borg2 : BoardPlayer = get_node("BorgPlayer2")
onready var playerSpot : Light2D = get_node("PlayerSpot")

onready var prompt : Label = get_node("prompt")
onready var titleText = get_node("TitleText")
onready	var tween : Tween = get_node("Tween")

onready var badSheep = get_node("BadSheep")
onready var click : AudioStreamPlayer = get_node("click")

onready var menuScene = get_node("Menu")
onready var spinScene = get_node("Spin")
onready var gameOverScene = get_node("GameOver")
onready var aboutScene = get_node("About")

onready var fence1 = get_node("Fence1")
onready var fence2 = get_node("Fence2")

onready var messageDialog : MessageDialog = get_node("MessageDialog")

var winner
var borgSheep : BorgSheep

var gameData : GameData

var fenceCount : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gameData = GameData.new()
	borgSheep = BorgSheep.new()
	var board = get_child(0);
	for child in board.get_children():
		if child.name.begins_with("Fence"):
			child.add_to_group("fences", true)
			child.connect("pressed", self, "on_fence_clicked", [child])
			
		if child.name.begins_with("Pen"):
			child.add_to_group("pens", true)
	
	setPlayerEntriesFromPlayerData()
	setPlayersFromPlayerData()
	setFencesFromBoardData()
	setPensFromBoardData()
	
	# if the initial state is not MENU or GAME_OVER then we have loaded an active game
	var newState = GameState.MENU
	if gameData.gameState != GameState.MENU && gameData.gameState != GameState.GAME_OVER:
		newState = gameData.gameState
		playerSpot.visible = true
		var thisBoardPlayer = matchPlayer(gameData.currentPlayer)
		playerSpot.set_position(thisBoardPlayer.get_position())
	
	
	gameData.gameState = GameState.GAME_OVER
	changeState(newState)


func _unhandled_key_input(event : InputEventKey):
	if !event.is_pressed():
		if !messageDialog.is_visible() && (gameData.gameState == GameState.MENU || gameData.gameState == GameState.SPIN):
			if event.scancode == KEY_ESCAPE || event.scancode == KEY_BACK:
				get_tree().set_input_as_handled()
				var caller
				var function
				if aboutScene.position.y == SHOW_Y:
					caller = aboutScene
					function = "_on_OkButton_pressed"
				elif gameData.gameState == GameState.MENU:
					caller = menuScene
					function = "_on_ExitButton_pressed"
				elif gameData.gameState == GameState.SPIN:
					caller = spinScene
					function = "_on_ExitButton_pressed"
				
				tween.interpolate_callback(caller, 0.01, function)
				tween.start()


func changeState(newState):
	if gameData.gameState == newState:
		return
	
	if gameData.gameState == GameState.GAME_OVER:
		prompt.set_text("")
		hideNode(gameOverScene)
	
	if gameData.gameState == GameState.SPIN:
		hideNode(spinScene)
	
	if gameData.gameState == GameState.MENU:
		titleText.zoom(false)
		hideNode(menuScene)
	
	if gameData.gameState == GameState.FENCE1:
		fence1.set_visible(false)
		fence2.set_visible(false)
	
	if gameData.gameState == GameState.FENCE1 || gameData.gameState == GameState.FENCE2:
		if checkGameOver():
			newState = GameState.GAME_OVER
	
	if newState == GameState.MENU:
		titleText.zoom(true)
		showNode(menuScene)
	
	if newState == GameState.START:
		startGame()
		tween.interpolate_callback(self, 0.01, "changeState", GameState.SPIN)
		tween.start()
	
	if newState == GameState.SPIN:
		prompt.set_text("")
		if gameData.gameState == GameState.START:
			playerSpot.visible = true
		if gameData.gameState == GameState.START || gameData.gameState == GameState.FENCE1 || gameData.gameState == GameState.BAD_SHEEP:
			nextPlayer()
		
		spinScene.setPlayer(gameData.currentPlayer, gameData.players[gameData.currentPlayer].playerName)
		showNode(spinScene)
		if gameData.players[gameData.currentPlayer].isBorg:
			tween.interpolate_callback(spinScene, 0.3, "_on_SpinButton_pressed")
			tween.start()
	
	
	if newState == GameState.FENCE1:
		if gameData.gameState == GameState.FENCE2:
			fence1.set_visible(false)
			prompt.set_text(SECOND_FENCE_PROMPT)
		else:
			fence1.set_visible(true)
			prompt.set_text(SINGLE_FENCE_PROMPT)
		fenceCount = 1
	
	if newState == GameState.FENCE2:
		fence1.set_visible(true)
		fence2.set_visible(true)
		prompt.set_text(FENCE2_PROMPT)
		fenceCount = 2
	
	if (newState == GameState.FENCE1 || newState == GameState.FENCE2) && gameData.players[gameData.currentPlayer].isBorg:
		borgSheep.DoFence(self, fenceCount)
	
	if newState == GameState.BAD_SHEEP:
		prompt.set_text(BAD_SHEEP_PROMPT)
		tween.interpolate_callback(badSheep, 0.001, "startBadSheep")
		tween.start()
	
	if newState == GameState.GAME_OVER:
		playerSpot.visible = false
		prompt.set_text("")
		gameOverScene.setPlayer(winner, gameData.players[winner].playerName)
		showNode(gameOverScene)
	
	gameData.gameState = newState
	gameData.save_game()


func startGame():
	resetFences()
	resetPens()
	resetPlayerData()
	gameData.currentPlayer = BoardData.PenType.COMPUTER2
	for i in range(BoardData.PenType.PINK, BoardData.PenType.COMPUTER1):
		gameData.players[i].playerName = menuScene.getPlayerName(i)
		gameData.players[i].enabled = menuScene.getPlayerEnabled(i)
	
	var playerCount=0
	for i in range(BoardData.PenType.PINK, BoardData.PenType.COMPUTER1):
		if gameData.players[i].enabled:
			playerCount+=1
	
	var currentSheepCount
	match playerCount:
		0:
			currentSheepCount = 6
			gameData.players[BoardData.PenType.COMPUTER1].enabled = true;
			gameData.players[BoardData.PenType.COMPUTER2].enabled = true;
		1:
			currentSheepCount = 6
			gameData.players[BoardData.PenType.COMPUTER1].enabled = true;
		2:
			currentSheepCount = 6
		3:
			currentSheepCount = 5
		4:
			currentSheepCount = 4
	
	for i in BoardData.PenType.NONE:
		gameData.players[i].sheepCount = currentSheepCount
	
	setPlayersFromPlayerData()


func exitGame():
	get_tree().quit()


func resetFences():
	gameData.boardData.reset_fences()
	setFencesFromBoardData()


func setFencesFromBoardData():
	for i in BoardData.HORIZ_ROWS:
		for j in BoardData.HORIZ_COLS:
			var button = get_node("board/FenceH" + String(i) + String(j))
			button.set_disabled(gameData.boardData.horiz_fences[i][j])
	
	for i in BoardData.VERT_ROWS:
		for j in BoardData.VERT_COLS:
			var button = get_node("board/FenceV" + String(i) + String(j))
			button.set_disabled(gameData.boardData.vert_fences[i][j])


func resetPens():
	gameData.boardData.reset_pens()
	setPensFromBoardData()


func setPensFromBoardData():
	for i in BoardData.VERT_ROWS:
		for j in BoardData.HORIZ_COLS:
			var pen = get_node("board/Pen" + String(i) + String(j))
			pen.setPen(gameData.boardData.pens[i][j])


func resetPlayerData():
	gameData.resetPlayerData()
	setPlayersFromPlayerData()


func setPlayersFromPlayerData():
	for i in BoardData.PenType.NONE:
		setPlayer(i)


func setPlayerEntriesFromPlayerData():
	for i in BoardData.PenType.NONE:
		menuScene.setPlayerName(i, gameData.players[i].playerName)
		menuScene.setPlayerEnabled(i, gameData.players[i].enabled)


func matchPlayer(player):
	if player == BoardData.PenType.PINK:
		return pinkPlayer
	if player == BoardData.PenType.YELLOW:
		return yellowPlayer
	if player == BoardData.PenType.BLUE:
		return bluePlayer
	if player == BoardData.PenType.GREEN:
		return greenPlayer
	if player == BoardData.PenType.COMPUTER1:
		return borg1
	if player == BoardData.PenType.COMPUTER2:
		return borg2


func setPlayer(player):
	var thisBoardPlayer = matchPlayer(player)
	if gameData.players[player].enabled:
		thisBoardPlayer.visible = true
		thisBoardPlayer.setPlayerName(gameData.players[player].playerName)
		thisBoardPlayer.setPlayerCount(gameData.players[player].sheepCount)
	else:
		thisBoardPlayer.visible = false


func nextPlayer():
	gameData.nextPlayer()
	
	var thisBoardPlayer = matchPlayer(gameData.currentPlayer)
	
	tween.interpolate_method(playerSpot, "set_position", playerSpot.position, thisBoardPlayer.get_position(),
		0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



func showNode(node : Node2D):
	tween.interpolate_property(node, "position", node.position, Vector2(node.position.x, SHOW_Y),
		0.3, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()


func hideNode(node : Node2D):
	tween.interpolate_property(node, "position", node.position, Vector2(node.position.x, HIDE_Y),
		0.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func on_fence_clicked(button):
	if fenceCount == 0:
		return
	
	var type = button.name.substr(5, 1)
	var row : int = button.name.substr(6, 1).to_int()
	var col : int = button.name.substr(7, 1).to_int()

	fenceCount-=1
	gameData.boardData.setFence(type, row, col)
	click.play()
	
	if button is BaseButton:
		button.set_disabled(true)
	
	var duration = 0.2
	if checkPens(type, row, col):
		duration = 0.4
	
	var state = GameState.SPIN
	if gameData.gameState == GameState.FENCE2:
		state = GameState.FENCE1
		duration = 0.2
	tween.interpolate_callback(self, duration, "changeState", state)
	tween.start()


func checkGameOver() -> bool:
	for i in BoardData.PenType.NONE:
		if gameData.players[i].sheepCount == 0:
			winner = gameData.currentPlayer
			return true
	
	return false


func checkPens(type : String, row : int, col : int) -> bool :
	var penSet = false
	# for horizontal fences we check the pens above and below
	if type == 'H':
		if row > 0:
			if checkAPen(row - 1, col):
				setPen(row - 1, col)
				penSet = true;
		if row < BoardData.VERT_ROWS:
			if checkAPen(row, col):
				setPen(row, col)
				penSet = true;
		
	# for vertical fences we check the pens left and right
	if type == 'V':
		if col > 0:
			if checkAPen(row, col - 1):
				setPen(row, col - 1)
				penSet = true;
		if col < BoardData.HORIZ_COLS:
			if checkAPen(row, col):
				setPen(row, col)
				penSet = true;
	return penSet


func checkAPen(row : int, col : int) -> bool :
	# check all 4 fences are set for this pen
	# above
	if !gameData.boardData.isFenceSet('H', row, col):
		return false
	# below
	if !gameData.boardData.isFenceSet('H', row + 1, col):
		return false
	# left
	if !gameData.boardData.isFenceSet('V', row, col):
		return false
	# right
	if !gameData.boardData.isFenceSet('V', row, col + 1):
		return false
	return true


func setPen(row : int, col : int):
	gameData.boardData.setPen(row, col, gameData.currentPlayer)
	var pen : Pen = get_node("board/Pen"+String(row)+String(col))
	pen.setPen(gameData.currentPlayer)
	gameData.players[gameData.currentPlayer].sheepCount-=1
	var thisBoardPlayer = matchPlayer(gameData.currentPlayer)
	thisBoardPlayer.setPlayerCount(gameData.players[gameData.currentPlayer].sheepCount)

