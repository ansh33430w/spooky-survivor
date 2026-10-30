extends CanvasLayer


@onready var hpbar: ProgressBar = $hpbar
@onready var level: Label = $level


func sethp(hp,maxhp):
	hpbar.max_value = maxhp
	
	hpbar.value = hp
	


func setlevel(lvl):
	level.text = "LVL : "  + str(lvl)
