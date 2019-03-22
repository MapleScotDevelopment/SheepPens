extends Node

#const Main = preload("res://Scripts/main.gd")
const BoardData = preload("res://Scripts/BoardData.gd")

const BORG_DELAY : float = 0.3

var main
var tween

class FenceLocation:
	var type : String
	var row : int
	var col : int
	
	func _init(type, row, col) -> void:
		self.type = type
		self.row = row
		self.col = col


var singleFenceLocations = []
var doubleFenceLocations = []
var safeSingleFenceLocations = []
var safeDoubleFenceLocations = []
var unsafeFenceLocations = []


func DoFence(main, numFences : int):
	self.main = main
	tween = main.get_node("Tween")
	CheckPens()

	# 1 fence gives us a pen
	if singleFenceLocations.size() > 0:
		var pick = randi() % singleFenceLocations.size()
		PlaceFence(singleFenceLocations[pick])
		return
	
	# 2 fences gives us a pen
	if numFences == 2 && doubleFenceLocations.size() > 0:
		var pick = randi() % doubleFenceLocations.size()
		PlaceFence(doubleFenceLocations[pick])
		return
	
	# placing 1 fence is safe
	if safeSingleFenceLocations.size() > 0:
		var pick = randi() % safeSingleFenceLocations.size()
		PlaceFence(safeSingleFenceLocations[pick])
		return
	
	# placing 1 fence will create a 2 fence pen
	if safeDoubleFenceLocations.size() > 0:
		var pick = randi() % safeDoubleFenceLocations.size()
		PlaceFence(safeDoubleFenceLocations[pick])
		return
	
	# placing 1 fence will create a 3 fence pen
	if unsafeFenceLocations.size() > 0:
		var pick = randi() % unsafeFenceLocations.size()
		PlaceFence(unsafeFenceLocations[pick]);
		return


func CheckPens():
	singleFenceLocations.clear()
	doubleFenceLocations.clear()
	safeSingleFenceLocations.clear()
	safeDoubleFenceLocations.clear()
	unsafeFenceLocations.clear()
	
	# iterate over horizontal fences and test the above and below pens
	for row in BoardData.HORIZ_ROWS:
		for col in BoardData.HORIZ_COLS:
			if (main.gameData.boardData.horiz_fences[row][col]):
				continue
			var aboveCount = 0
			if row > 0:
				aboveCount = CountFences(row - 1, col)
			var belowCount = 0
			if (row < BoardData.VERT_ROWS):
				belowCount = CountFences(row, col)
			
			AddFenceToLocations('H', row, col, max(aboveCount, belowCount))
	
	# iterate over vertical fences and test the left and right pens
	for row in BoardData.VERT_ROWS:
		for col in BoardData.VERT_COLS:
			if (main.gameData.boardData.vert_fences[row][col]):
				continue
			var leftCount = 0
			if (col > 0):
				leftCount = CountFences(row, col - 1)
			var rightCount = 0;
			if (col < BoardData.HORIZ_COLS):
				rightCount = CountFences(row, col)
			
			AddFenceToLocations('V', row, col, max(leftCount, rightCount))


func AddFenceToLocations(fenceType, row : int, col : int, count : int):
	match count:
		3:
			# find the unset fence and add it to single
			singleFenceLocations.append(FenceLocation.new(fenceType, row, col))
			return
		2:
			var newFence = FenceLocation.new(fenceType, row, col)
			doubleFenceLocations.append(newFence)
			unsafeFenceLocations.append(newFence)
			return
		1:
			safeDoubleFenceLocations.append(FenceLocation.new(fenceType, row, col))
			return
		0:
			safeSingleFenceLocations.append(FenceLocation.new(fenceType, row, col))
			return


func CountFences(row, col) -> int :
	var count = 0;
	# count how many fences already placed
	var above = main.gameData.boardData.horiz_fences[row][col]
	var below = main.gameData.boardData.horiz_fences[row + 1][col]
	var left = main.gameData.boardData.vert_fences[row][col]
	var right = main.gameData.boardData.vert_fences[row][col + 1]
	
	if above:
		count+=1
	if below:
		count+=1
	if left:
		count+=1
	if right:
		count+=1
	return count;


func PlaceFence(var fence):
	var button = main.get_node("/root/Main/board/Fence"+String(fence.type)+String(fence.row)+String(fence.col))
	tween.interpolate_callback(main, BORG_DELAY, "on_fence_clicked", button)
	tween.start()
