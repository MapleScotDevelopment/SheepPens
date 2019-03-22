extends Object

const BoardData = preload("res://Scripts/BoardData.gd")

const SAVE_GAME_FILE = "user://sheep_pens.save"

class PlayerData:
	var playerName : String
	var enabled : bool
	var sheepCount : int
	var isBorg : bool

var currentPlayer
var gameState
var boardData : BoardData

var players = []


func _init() -> void:
	boardData = BoardData.new()
	
	for i in range(BoardData.PenType.PINK, BoardData.PenType.NONE):
		players.append(PlayerData.new())
	resetPlayerData()
	gameState = 0
	load_game()

func resetPlayerData():
	for i in BoardData.PenType.NONE:
		players[i].playerName = ""
		players[i].enabled = false
		players[i].sheepCount = 0
		players[i].isBorg = false
	
	players[BoardData.PenType.COMPUTER1].playerName = "One of Two"
	players[BoardData.PenType.COMPUTER1].isBorg = true
	players[BoardData.PenType.COMPUTER2].playerName = "Two of Two"
	players[BoardData.PenType.COMPUTER2].isBorg = true


func nextPlayer():
	if currentPlayer == BoardData.PenType.COMPUTER2:
		currentPlayer = BoardData.PenType.PINK
	else:
		currentPlayer+=1
	
	while !players[currentPlayer].enabled:
		if currentPlayer == BoardData.PenType.COMPUTER2:
			currentPlayer = BoardData.PenType.PINK
		else:
			currentPlayer+=1

func save_game():
	var save_game = File.new()
	save_game.open(SAVE_GAME_FILE, File.WRITE)
	var save_dict = serialise()
	var jsonData = to_json(save_dict)
	save_game.store_line(jsonData)
	save_game.close()


func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_GAME_FILE):
		return # Error! We don't have a save to load.
	
	save_game.open(SAVE_GAME_FILE, File.READ)
	var jsonData = save_game.get_line()
	
	var load_dict = parse_json(jsonData)
	save_game.close()
	deserialise(load_dict)


func serialise() -> Dictionary:
	var result = {
		"currentPlayer": currentPlayer,
		"gameState": gameState
	}
	
	for i in players.size():
		result["player_"+String(i)] = {
			"playerName": players[i].playerName,
			"enabled": players[i].enabled,
			"sheepCount": players[i].sheepCount,
			"isBorg" : players[i].isBorg
		}
	
	result["boardData"] = boardData.serialise()
	return result


func deserialise(dict : Dictionary):
	currentPlayer = dict["currentPlayer"]
	gameState = dict["gameState"]
	for i in players.size():
		var p_dict = dict["player_"+String(i)]
		players[i].playerName = p_dict["playerName"]
		players[i].enabled = p_dict["enabled"]
		players[i].sheepCount = int(p_dict["sheepCount"])
		players[i].isBorg = p_dict["isBorg"]
	
	boardData.deserialise(dict["boardData"])
