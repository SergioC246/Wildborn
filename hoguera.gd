extends StaticBody3D

var jugador = null


func _ready() -> void:
	$ZonaInteraccion.body_entered.connect(_on_body_entered)
	$ZonaInteraccion.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if jugador and Input.is_action_just_pressed("interactuar"):
		jugador.cocinar_carne()


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador = body


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador = null
