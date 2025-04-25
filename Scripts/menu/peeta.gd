extends TextureButton
var up = false
var right = true
var moveSpeed = 5
var newPos:Vector2 = Vector2(get_position().x, get_position().y) 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr:Array = []
	for i in 10:
		arr.append([])
		for j in 10:
			arr[i].append(0)
	
	print(arr)
	var newArr = arr
	newArr[0][0] += 100
	print(arr)
			
	
	
	pass
	# Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Check if button within bounds and adjust pos accordingly for x
	if($".".get_position().x + $".".get_size().x >= 1151):
		right = false
	elif($".".get_position().x <= 0):
		right = true
	if(right):
		newPos.x += moveSpeed
	else:
		newPos.x -= moveSpeed
	
	#For y alternatively
	if($".".get_position().y + $".".get_size().y >= 648):
		up = true 
	elif($".".get_position().y <= 0):
		up = false
	if(up):
		newPos.y -= moveSpeed
	else:
		newPos.y += moveSpeed
	#print(newPos)
	#print(up)
	#print(right)
	#print(" " + up.to_string() + " " + right.to_string() + "\n")
	$".".set_position(newPos)
