@tool
## Gera uma masmorra usando o algoritmo Simple Random Walk.
class_name RandomWalkGeneration
extends Node

## A posição inicial para a primeira caminhada aleatória.
@export var posicaoInicial: Vector2i = Vector2i.ZERO
## Os parâmetros de configuração para o algoritmo de caminhada aleatória.
@export var random_walk_parameters: RandomWalkData

## Referência ao TileMapVisualizer para desenhar a masmorra gerada.
@export var tilemapVisualizer: TileMapVisualizer

## Limpa o mapa anterior, executa o algoritmo de geração e desenha o novo mapa de tiles.
func runProceduralGeneration() -> void:
	var floorPosition: Dictionary[Vector2i, bool] = runRandomWalk(random_walk_parameters, posicaoInicial)
	var listfloorPositions = floorPosition.keys()
	
	if not is_instance_valid(tilemapVisualizer):
		push_error("Visualizador de mapa não atribuido! Não é possivel gerar")
		return
	tilemapVisualizer.limpar_piso()
	tilemapVisualizer.paint_floor_tiles(listfloorPositions)
	WallGenerator.create_walls(floorPosition, tilemapVisualizer)

## Executa o algoritmo Simple Random Walk com base nos parâmetros definidos.
## Retorna um dicionário com as posições do chão geradas.
func runRandomWalk(parameters: RandomWalkData, position: Vector2i) -> Dictionary[Vector2i, bool]:
	var currentPosition: Vector2i = position
	
	var floorPosition: Dictionary[Vector2i, bool]
	
	for i in range(parameters.iterations):
		var path = ProceduralGeneration.simpleRandomWalk(currentPosition, parameters.walkLength)
		floorPosition.merge(path, true)
		
		if parameters.startRandomly:
			var all_keys: Array[Vector2i] = floorPosition.keys()
			
			var random_index: int = randi() % all_keys.size()
				
			var random_key: Vector2i = all_keys[random_index]
				
			currentPosition = random_key
			
	return floorPosition
