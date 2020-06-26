extends KinematicBody2D

class_name PlayerController

const FLOOR_NORM = Vector2(0, -1)
var motion = Vector2()

var speed = 300
var jump_vel = -400
var jump_buff_length = 4
var jump_coyote_time = 4
var grav = 50

var pole_zero = {
	bh = -500,
	bd = 200,
	hg = -10,
	dg = -5
}
var pole_one = {
	bh = -500,
	bd = 200,
	hg = -10,
	dg = -5
}
var pole_two = {
	bh = -500,
	bd = 200,
	hg = -10,
	dg = -5
}
var pole_three = {
	bh = -500,
	bd = 200,
	hg = -10,
	dg = -5
}

var pole_positions = {
	0: PolePosition.new(pole_zero.bh, pole_zero.bd, pole_zero.hg, pole_zero.dg),
	1: PolePosition.new(pole_one.bh, pole_one.bd, pole_one.hg, pole_one.dg),
	2: PolePosition.new(pole_two.bh, pole_two.bd, pole_two.hg, pole_two.dg),
	3: PolePosition.new(pole_three.bh, pole_three.bd, pole_three.hg, pole_three.dg),
	cur_pole_pos = 1,
	head = 0,
	tail = 3
}

var jump_buff = {
	"b_pos": -1, 
	"b_end": jump_buff_length, 
	"c_pos": -1, 
	"c_end": jump_coyote_time, 
	"buffered": false,
	"in_c_time": false,
	"on_floor_last_frame": false
}
####################################
func _process(delta):
	analyze_input()
	pass

func _physics_process(delta):
	motion = move_and_slide(motion, FLOOR_NORM)
	pass
####################################
func analyze_input():
	if Input.is_action_pressed("vault"):
		motion.x = 0
		motion.y = 0
		pole_positions[pole_positions.cur_pole_pos].next_trajectory()
	elif Input.is_action_just_released("vault"):
		motion = pole_positions[pole_positions.cur_pole_pos].final_trajectory()
	else:
		hor_motion()
		vert_motion(1)

func hor_motion():
	if Input.is_action_pressed("move_right"):
		motion.x = speed
	elif Input.is_action_pressed("move_left"):
		motion.x = -speed
	else:
		motion.x = 0

func vert_motion(mod):
	update_jump_buff()
	if is_on_floor() && jump_buff["buffered"]:
		motion.y = jump_vel
		reset_buffer()
	elif jump_buff["in_c_time"] && Input.is_action_just_pressed("jump"):
		motion.y = jump_vel
		reset_buffer()
	else:
		motion.y += grav*mod

func update_jump_buff():
	# buffer time stepping
	var pos = jump_buff["b_pos"]
	var end = jump_buff["b_end"]
	if Input.is_action_just_pressed("jump") && pos == -1:
		pos = 0
	elif pos != -1:
		if pos != end:
			pos += 1
		else: 
			pos = -1
	jump_buff["b_pos"] = pos
	# coyote time stepping
	pos = jump_buff["c_pos"]
	end = jump_buff["c_end"]
	if jump_buff["on_floor_last_frame"]:
		pos = 0
	elif pos != -1:
		if pos != end:
			pos += 1
		else:
			pos = -1
	jump_buff["c_pos"] = pos
	#finalize buffer/coyote time
	if jump_buff["b_pos"] != -1:
		jump_buff["buffered"] = true
	else:
		jump_buff["buffered"] = false
	if jump_buff["c_pos"] != -1:
		jump_buff["in_c_time"] = true
	else:
		jump_buff["in_c_time"] = false
	if is_on_floor():
		jump_buff["on_floor_last_frame"] = true
	else:
		jump_buff["on_floor_last_frame"] = false

func reset_buffer():
	jump_buff["b_pos"] = -1
	jump_buff["buffered"] = false
	jump_buff["c_pos"] = -1
	jump_buff["in_c_time"] = false

func vault():
	return true

class PolePosition:
	var base_height
	var base_distance
	var height_growth
	var distance_growth
	
	var trajectory
	var release_trajectory

	func _init(bh, bd, hg, dg):
		base_height = bh
		base_distance = bd
		height_growth =hg
		distance_growth = dg
		
	func next_trajectory():
		if trajectory == null:
			trajectory = Vector2(base_distance, base_height)
		else:
			trajectory.x = trajectory.x + distance_growth
			trajectory.y = trajectory.y + height_growth
	
	func final_trajectory():
		var ret = trajectory
		trajectory = null
		return ret
