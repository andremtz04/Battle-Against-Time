extends Node

var roundCounter : int = 1
var enemykilled : int = 0
var totalRounds : int = 5
var roundStarted : bool = false
var didWin : bool = false

# [# of enemy, time of spawn]
var path1D : Dictionary = {
	1 : [10,3],
	2 : [15,2], 
	3 : [20,3],
	4 : [25,2],
	5 : [30, 2]
}
