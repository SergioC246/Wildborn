extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const COSTE_HOGUERA = 5
const ESCENA_HOGUERA = preload("res://hoguera.tscn")

var madera = 0
@onready var contador_madera = $CanvasLayer/ContadorMadera


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("construir"):
		construir_hoguera()


func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento
	var input_dir := Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func agregar_madera(cantidad: int) -> void:
	madera += cantidad
	actualizar_contador()


func actualizar_contador() -> void:
	contador_madera.text = "Madera: " + str(madera)


func construir_hoguera() -> void:
	if madera < COSTE_HOGUERA:
		print("No tienes suficiente madera. Necesitas ", COSTE_HOGUERA)
		return

	madera -= COSTE_HOGUERA
	actualizar_contador()

	var hoguera = ESCENA_HOGUERA.instantiate()
	get_parent().add_child(hoguera)
	hoguera.global_position = global_position + Vector3(0, 0, -2)
	print("¡Hoguera construida!")
