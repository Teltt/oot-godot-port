@tool
extends Area2D
class_name Sorter
@onready var bot = $Base
@onready var bbox = $BBox
@export var default_depth:int = 30
var center_point:Vector2
var radius = 1.0
var id = 99999
var parent:Node2D
var sorted_dict:Dictionary= {}
var up_neighbors:Array = []
var down_neighbors:Array = []
var y_sort = self
var visited_up = false
var visited_down = false
var left_p
var right_p
var total_up_neighbors = 0
var total_down_neighbors = 0

@onready var area2d = $Area2D
@export var height = 0.0:
	set(value):
		height = value
		if bot != null:
			
			construct_bbox(height)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	construct_bbox(height)
	if not Engine.is_editor_hint():
		set_visible(false)


static func find_closest(cen,closest,line1,line2):
	var temp = Geometry2D.get_closest_point_to_segment(cen,line1,line2)
	if cen.distance_to(closest) < temp.distance_to(cen):
		return temp
	return closest
	
func up_depth_search(stack=[]):
	if visited_up:
		return total_up_neighbors
	visited_up = true
	total_up_neighbors = up_neighbors.size()
	for n in up_neighbors:
		if n.y_sort != self  and n.y_sort.get_viewport() == get_viewport():
			stack.push_back(n)
	while stack.size() > 0:
		if stack.size() <= 0:
			break
		else:
			
			var st0 = stack.pop_front()
			
			var ret = st0.y_sort.up_depth_search()
			total_up_neighbors
	return total_up_neighbors
func down_depth_search(stack=[]):
	if visited_down:
		return total_down_neighbors
	visited_down = true
	total_down_neighbors = down_neighbors.size()
	for n in down_neighbors:
		if  n.y_sort != self  and n.y_sort.get_viewport() == get_viewport():
			stack.push_back(n)
			
	while stack.size() > 0:
		
		if stack.size() <= 0:
			break
		else:
			
			var st0 = stack.pop_front()
			var ret = st0.y_sort.down_depth_search()
			total_down_neighbors+= ret
	return total_down_neighbors
func update_neighbors():
	visited_up = false
	visited_down = false
	total_up_neighbors = 0
	total_down_neighbors = 0
	var cen_neighbors = []
	var my_up_neighbors = get_overlapping_areas().filter(func(ele):
		return ele.name != "YSort")
	var my_down_neighbors=($Shadow.get_overlapping_areas().filter(func(ele):
		return ele.name != "Shadow"))
	for n in my_up_neighbors:
		if n.y_sort != self and n.y_sort.get_viewport() == get_viewport():
			if self not in n.y_sort.down_neighbors:
				n.y_sort.down_neighbors.append(self)
			if n.y_sort not in up_neighbors:
				up_neighbors.append(n.y_sort)
	for n in my_down_neighbors:
		if n.y_sort != self and n.y_sort.get_viewport() == get_viewport():
			if self not in n.y_sort.up_neighbors:
				n.y_sort.up_neighbors.append(self)
			if n.y_sort not in down_neighbors:
				down_neighbors.append(n.y_sort)
#func tick(upstack = []):
#	visited = true
#	for s in $Area2D.get_overlapping_areas():
#		if s.name == "Shadow" or s == self or s == $Area2D:
#			continue
#		if s in upstack:
#			continue
#		if s.name == "YSort":
#			add_to_sorted_dict(s.y_sort,1)
#		if not s.y_sort.visited:
#			s.y_sort.tick()
#		pass

func add_to_sorted_dict(key,value):
		SorterGlobal.sorted_dict[key.parent]= SorterGlobal.sorted_dict[parent]+value
		SorterGlobal.object_to_sorter[key.parent] = key.y_sort
static func calculateLineSlopeAndYIntercept(point1: Vector2, point2: Vector2):
	var slope = (point2.y - point1.y) / (point2.x - point1.x)
	var y_intercept = point1.y - slope * point1.x
	return [slope, y_intercept]
func con(point):
	return bbox.to_local(bot.to_global(point))/global_scale
func construct_bbox(height):
	var height_adder = Vector2(0,height)
	
	var x_adder = Vector2(0,0.0)
	var high_point = Vector2(0.0,-99999)
	var low_point = Vector2(0.0,99999)
	var left_point = Vector2(99999,0.0)
	var right_point = Vector2(-99999,0.0)
	var p:Array = bot.points
	for poin in p:
		var point = con(poin)
		if point.y > high_point.y:
			high_point = point
		if point.y < low_point.y:
			low_point = point
		if point.x > right_point.x:
			right_point = point
		if point.x < left_point.x:
			left_point = point
	var bp = [
		left_point+x_adder,
		Vector2(left_point.x,low_point.y)+height_adder+x_adder,
		low_point+height_adder,
		Vector2(right_point.x,low_point.y)+height_adder-x_adder,
		right_point-x_adder,
		]
	$CollisionPolygon2D.set_polygon(bp)
	center_point = average_points(bp)
	for point in bp:
		radius = max(radius,point.distance_to(center_point))
	bp = [
		high_point,
		Vector2(left_point.x,high_point.y),
		left_point,
		Vector2(left_point.x,low_point.y),
		low_point,
		Vector2(right_point.x,low_point.y),
		right_point,
		Vector2(right_point.x,high_point.y),
		]
	bbox.set_points(bp)
#	bp = [
#		left_point,
#		Vector2(left_point.x,high_point.y),
#		high_point,
#		Vector2(right_point.x,high_point.y),
#		right_point,
#	]
#	$Area2D/CollisionPolygon2D.set_polygon(bp)
	bp = [
		#left_point,
		left_point+x_adder,
		Vector2(left_point.x,low_point.y)-height_adder*0.5+x_adder,
		low_point-height_adder*0.5,
		Vector2(right_point.x,low_point.y)-height_adder*0.5-x_adder,
		right_point-x_adder,
		#right_point,
	]
	$Shadow/CollisionPolygon2D.set_polygon(bp)
	left_p = left_point
	right_p = left_point
	center_point = ((left_point)+(left_point-left_point).normalized()*(left_point-left_point).length()*0.5)
	

static func average_points(point_array):
	var cen = Vector2(0,0)
	var amount = 0
	for point in point_array:
		amount+=1
		cen+= point
	cen /= amount
	return cen
static func organizePoints(p):
	p.sort_custom(func(a,b):
		if a.x < b.x:
			return true
		else:
			return false
			)
	return p

static func calc(point: Vector2, line1:Vector2,line2:Vector2):
	var v=Geometry2D.get_closest_point_to_segment(point,line1,line2)

	return v
static func intesect(line1,line2,plin1,plin2):
	
	var v = [Geometry2D.line_intersects_line(line1,(line2-line1).normalized(),
	plin1,(plin2-plin1).normalized()),
		Geometry2D.line_intersects_line(line2,(line1-line2).normalized(),
	plin2,(plin1-plin2).normalized()),
	Geometry2D.line_intersects_line(line2,(line1-line2).normalized(),
	plin1,(plin2-plin1).normalized()),
		Geometry2D.line_intersects_line(line1,(line2-line1).normalized(),
	plin2,(plin1-plin2).normalized())]
	for p in v:
		if p == null:
			continue
		else:
			return p
	return ((plin1)+(plin1-plin2).normalized()*(plin1-plin2).length()*0.5)
func _draw():
	draw_line((bbox.points[2]),(bbox.points[6]),Color.WHEAT,3.16)
