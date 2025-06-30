@tool
extends Node

func simpleRandomWalk(startPosition: Vector2i, walkLenght: int) -> Dictionary[Vector2i, bool]:
	
	var path: Dictionary[Vector2i, bool]  = {}
	
	if not path.has(startPosition):
		path[startPosition] = true
	
	var posicaoAnterior = startPosition;
	
	for i in range(walkLenght):
		var novaPosicao = posicaoAnterior + Direction2D.getRandomCardinalDirection()
		path[novaPosicao] = true;
		posicaoAnterior = novaPosicao;
	
	return path
	

func randomwalk_corridor(start_position: Vector2i, tamanho_corredor: int) -> Array[Vector2i]:
	var corredor: Array[Vector2i] = []
	var direction = Direction2D.getRandomCardinalDirection();
	var current_position = start_position
	
	for i in range (tamanho_corredor):
		current_position += direction
		corredor.append(current_position)
	
	return corredor
