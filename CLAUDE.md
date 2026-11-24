# Wildborn: Dawn of Dominion

Juego de supervivencia de mundo abierto para un jugador, hecho en **Godot 4.7.2** con **GDScript**.
Empiezas como exiliado sin nada en una tierra salvaje (Wildmarch) y acabas liderando una civilización que avanza por eras (primitiva → medieval → pólvora → industrial).

## Documento de diseño

**[docs/diseno.md](docs/diseno.md)** es la fuente de verdad del diseño del juego y de la hoja de ruta (sección 13). Tenlo siempre en cuenta:

- Antes de planificar una tarea, comprueba en qué fase de la hoja de ruta encaja y qué dice el diseño sobre ella.
- Las decisiones marcadas como **(decidido)** están cerradas: no las cambies ni propongas algo que las contradiga sin hablarlo antes con Sergio.
- Si una tarea obliga a tomar una decisión de diseño nueva, pregunta a Sergio en lugar de decidir tú.

(Versión antigua en línea: https://claude.ai/artifact/8UVPNMUYDQqWahv1vSCVZm. Si no coincide, manda `docs/diseno.md`.)

## Quién trabaja en este proyecto

Sergio, desarrollador junior full stack (JavaScript, React, Python) que está aprendiendo Godot con este proyecto.
Su objetivo es aprender a dirigir y revisar el trabajo de la IA, no solo recibir código.

## Reglas de trabajo

1. **Explica siempre en español** qué vas a cambiar y por qué, con palabras sencillas. Cuando uses algo nuevo de Godot, explícalo con una comparación de desarrollo web si ayuda.
2. **Un cambio cada vez.** No metas varias funciones nuevas a la vez. No toques lo que no se ha pedido.
3. **No rompas lo que ya funciona.** Si un cambio afecta a otros sistemas, avisa antes.
4. **Para cambios grandes, propón un plan primero** y espera a que Sergio diga que sí.
5. **Al terminar cada tarea:** di cómo probarlo en el juego (qué teclas, qué debería pasar) y sugiere un mensaje de commit. Si algo ha cambiado (archivos, nodos, sistemas, lecciones aprendidas), propón también actualizar este CLAUDE.md. Si la tarea completa algo de la hoja de ruta, o se ha tomado una decisión de diseño nueva, propón marcarlo o anotarlo en `docs/diseno.md`.
6. **No hagas commits ni push** sin que Sergio lo pida.
7. **Escenas (.tscn):** edítalas con cuidado. Si un cambio es más seguro o didáctico hacerlo en el editor de Godot, da los pasos exactos (qué nodo, qué propiedad del Inspector, qué valor) en lugar de editar el archivo.

## Convenciones de código

- Nombres de **nodos** en PascalCase y en español, sin tildes ni ñ: `Jugador`, `ZonaInteraccion`, `BarraVida`.
- Nombres de **variables y funciones** en snake_case y en español, sin tildes ni ñ: `agregar_item`, `golpes_restantes`.
- Indentación con **tabulaciones**, nunca espacios.
- Valores que se quieran ajustar desde el Inspector: usar `@export`.
- Los mensajes de `print()` pueden llevar tildes.

## Estructura actual

| Archivo | Qué es |
|---|---|
| `mundo.tscn` | Escena principal: Suelo (500×500), Sol, Luna, WorldEnvironment, Jugador (con su hija `Camara`), árboles, rocas, arbustos, conejos y una hoguera |
| `jugador.tscn` + `jugador.gd` | CharacterBody3D. La cámara cenital (`Camara`) **no está aquí**: está en `mundo.tscn` como hija de la instancia `Jugador`. UI en `CanvasLayer`: `ContadorMadera` (texto de ayuda), `BarraVida`, `BarraHambre`, `BarraSed` e `Inventario/VBoxContainer/{Titulo, Casillas}` |
| `recurso.gd` | Script genérico para todo lo que se recolecta con E. `@export tipo_recurso, cantidad, golpes_necesarios`. Necesita un hijo `ZonaInteraccion` (Area3D) |
| `arbol.tscn`, `roca.tscn`, `arbusto.tscn`, `conejo.tscn` | Usan `recurso.gd` (madera / piedra / bayas / carne_cruda) |
| `hoguera.tscn` + `hoguera.gd` | Ilumina (OmniLight3D) y cocina carne con E si el jugador está en su `ZonaInteraccion` |
| `ciclo_dia.gd` | En el nodo `Sol`. Gira sol y luna, cambia el color de la luz y del cielo según la altura del sol, cruza suavemente las luces y sombras del sol y la luna, y muestra estrellas de noche (textura `NoiseTexture2D` en `Sky Cover` del `ProceduralSkyMaterial`). Todos los colores y rangos son `@export` agrupados en el Inspector |

## Sistemas existentes

- **Inventario:** diccionario `inventario` en `jugador.gd`. Funciones: `cantidad_de(item)`, `agregar_item(item, cantidad)`, `quitar_item(item, cantidad)`, `tiene_materiales(coste)`. Los nombres visibles están en la constante `NOMBRES`.
- **Recolección:** `recurso.gd` llama a `jugador.agregar_recurso(tipo, cantidad)`. Las bayas se comen directamente; el resto va al inventario.
- **Supervivencia:** vida, hambre y sed (`@export` en el jugador). Con el hambre o la sed a 0 se pierde vida (los daños se suman). Todavía no se puede beber. Al morir se vacía el inventario y se reaparece en la posición inicial.
- **Construcción:** B construye una hoguera delante del jugador con el coste `COSTE_HOGUERA` (diccionario).
- **Comida:** F come carne (prioriza la asada: +40 hambre; la cruda da +10 y quita 10 de vida).

## Acciones de entrada

`mover_izquierda` (A), `mover_derecha` (D), `mover_adelante` (W), `mover_atras` (S), `saltar` (Espacio), `interactuar` (E), `construir` (B), `comer` (F), `inventario` (TAB).

## Lecciones aprendidas

- La `ZonaInteraccion` (Area3D) debe ser **más grande** que la colisión sólida; si no, el jugador choca antes de entrar en la zona y la E no funciona.
- Al duplicar nodos con estilos (StyleBox) o materiales, usar **"Hacer único"** si deben ser independientes.
- No usar carpetas de OneDrive para el proyecto.
- La cámara actual mira hacia abajo y apenas ve el cielo: los colores del cielo se notan sobre todo a través de la **luz ambiente**. Para probar el cielo, girar la `Camara` temporalmente.
- `background_energy_multiplier` oscurece **todo** el cielo, estrellas incluidas; por eso `ciclo_dia.gd` compensa el brillo de las estrellas.
