extends Object

const HORIZ_ROWS = 4
const HORIZ_COLS = 5
const VERT_ROWS = 3
const VERT_COLS = 6

var horiz_fences = []
var vert_fences = []

var pens = []

enum PenType { PINK, YELLOW, BLUE, GREEN, COMPUTER1, COMPUTER2, NONE }

func _init():
	for i in HORIZ_ROWS:
		horiz_fences.append([])
		for j in range(HORIZ_COLS):
			horiz_fences[i].append(null)
		
	for i in VERT_ROWS:
		vert_fences.append([])
		for j in range(VERT_COLS):
			vert_fences[i].append(null)
			
	reset_fences()
	
	for i in VERT_ROWS:
		pens.append([])
		for j in HORIZ_COLS:
			pens[i].append(null)
			
	reset_pens()


func reset_fences():
	for i in HORIZ_ROWS:
		for j in HORIZ_COLS:
			horiz_fences[i][j] = false
			
	for i in VERT_ROWS:
		for j in VERT_COLS:
			vert_fences[i][j] = false


func reset_pens():
	for i in VERT_ROWS:
		for j in HORIZ_COLS:
			pens[i][j] = PenType.NONE


func setPen(row : int, col : int, type):
	pens[row][col] = type


func setFence(type, row : int, col : int):
	
	if type == 'H':
		horiz_fences[row][col] = true
	
	if type == 'V':
		vert_fences[row][col] = true


func isFenceSet(type, row, col) -> bool :
	if type == 'H':
		return horiz_fences[row][col]
		
	if type == 'V':
		return vert_fences[row][col]
		
	return false


func serialise() -> Dictionary:
	var result = {}
	
	for i in horiz_fences.size():
		for j in horiz_fences[i].size():
			result["FenceH"+String(i)+String(j)] = horiz_fences[i][j]
	
	for i in vert_fences.size():
		for j in vert_fences[i].size():
			result["FenceV"+String(i)+String(j)] = vert_fences[i][j]
	
	for i in pens.size():
		for j in pens[i].size():
			result["Pen"+String(i)+String(j)] = pens[i][j]

	return result


func deserialise(dict : Dictionary):
	for i in horiz_fences.size():
		for j in horiz_fences[i].size():
			horiz_fences[i][j] = dict["FenceH"+String(i)+String(j)]
	
	for i in vert_fences.size():
		for j in vert_fences[i].size():
			vert_fences[i][j] = dict["FenceV"+String(i)+String(j)]
	
	for i in pens.size():
		for j in pens[i].size():
			pens[i][j] = dict["Pen"+String(i)+String(j)]
