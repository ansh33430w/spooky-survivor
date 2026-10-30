extends CanvasLayer


signal chosen(id )

var pool = [
	{"id" : "damage" ,  "text" : "+1 Knife Damage"},
	{"id" : "firerate" ,  "text" : "faster throw"},
	{"id" : "pierce" ,  "text" : "+1 pierce"},
	{"id" : "speed" ,  "text" : "increased move speed"},
	{"id" : "heal" ,  "text" : "heal 30 hp"},
	]
@onready var v_box_container: VBoxContainer = $VBoxContainer

var current=[]

func _ready() -> void:
	hide()
	for i in 3 :
		v_box_container.get_child(i).pressed.connect(_on_pick.bind(i))

func show_choice(_level)->void:
	pool.shuffle()
	current=pool.slice(0,3)
	for i  in 3:
		v_box_container.get_child(i).text = current[i].text
	show()
	get_tree().paused = true
	


func _on_pick(i)-> void:
	chosen.emit(current[i].id)
	hide()
	get_tree().paused =false
