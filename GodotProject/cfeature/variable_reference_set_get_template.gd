extends Resource
var custom_get = false
var custom_set = true
func _set(property: StringName, value: Variant) -> bool:
	if property == "custom_get" or property == "custom_set":
		self[property] = value
		return true
	if self[property] == null:
		self[property] = Ref.new()
		self[property].v = value
	elif custom_set:
		self[property] = value
		return	true
	elif self[property] is Ref:
		var prev = custom_get
		custom_get = true
		self[property].v = value
		custom_get = prev
		return true
	return false
func _get(property: StringName) -> Variant:	
	if property == "custom_get" or property == "custom_set":
		return self[property]
	if self[property] is Ref and not custom_get:
		return self[property].v
	return self[property]
var recursion_stopper = false
func _get_property_list() -> Array[Dictionary]:
	if recursion_stopper:
		return []
	recursion_stopper = true
	var prop_list = get_property_list()
	recursion_stopper = false
	var prev = custom_get
	custom_get = true
	var list = []
	for prop in prop_list:
		if self[prop["name"]] is Ref:
			list.append({"name":prop["name"],"class_name":prop["class_name"],"type":typeof(self[prop["name"]].v)})
	custom_get = prev
	return list
