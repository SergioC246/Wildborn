extends StaticBody3D

var jugador_cerca = false
var golpes_restantes = 3
var jugador = null


func _ready() -> void:
	$ZonaInteraccion.body_entered.connect(_on_body_entered)
	$ZonaInteraccion.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		recibir_golpe()


func recibir_golpe() -> void:
	golpes_restantes -= 1
	print("¡Hachazo! Golpes restantes: ", golpes_restantes)
	if golpes_restantes <= 0:
		talar()


func talar() -> void:
	print("¡El árbol ha caído!")
	if jugador:
		jugador.agregar_madera(3)
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador_cerca = true
		jugador = body
		print("El jugador está cerca del árbol")


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador_cerca = false
		print("El jugador se ha alejado del árbol")
