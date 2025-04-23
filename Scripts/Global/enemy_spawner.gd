extends Node

var roundCounter : int = 1
var enemykilled : int = 0
var totalRounds : int = 5
var roundStarted : bool = false

# [# of enemy, time of spawn]
var path1D : Dictionary = {
	1 : [5,2],
	2 : [10,1], 
	3 : [15,2],
	4 : [20,1],
	5 : [25, 2]
}
