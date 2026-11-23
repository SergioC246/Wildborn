extends StaticBody3D

@export var tipo_recurso: String = "madera"
@export var cantidad: int = 3
@export var golpes_necesarios: int = 3

var golpes_restantes: int
var jugador_cerca = false
var jugador = null


func _ready() -> void:
	golpes_restantes = golpes_necesarios
	$ZonaInteraccion.body_entered.connect(_on_body_entered)
	$ZonaInteraccion.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		recibir_golpe()


func recibir_golpe() -> void:
	golpes_restantes -= 1
	print("¡Golpe! Golpes restantes: ", golpes_restantes)
	if golpes_restantes <= 0:
		recolectar()


func recolectar() -> void:
	print("Has conseguido ", cantidad, " de ", tipo_recurso)
	if jugador:
		jugador.agregar_recurso(tipo_recurso, cantidad)
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador_cerca = true
		jugador = body


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Jugador":
		jugador_cerca = false
