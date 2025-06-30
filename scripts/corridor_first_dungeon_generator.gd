@tool
extends RandomWalkGeneration

class_name CorridorFirstDungeonGenerator

@export var corridor_length: int  = 14; 
@export var corridor_count: int = 5;
@export_range(0.1,1,0.1) var room_percent: float = 0.8;

@export var executar_geracao: bool = false : set = _set_executar_geracao

func _set_executar_geracao(value):
	if value:
		runProceduralGeneration()
	executar_geracao = false

#Override
func runProceduralGeneration() -> void:
	corridor_first_generation()
	

func corridor_first_generation() -> void:
	var floor_positions: Dictionary[Vector2i, bool] = {}
	
	create_corridors(floor_positions)
	
	tilemapVisualizer.limpar_piso()
	tilemapVisualizer.paint_floor_tiles(floor_positions.keys())
	WallGenerator.create_walls(floor_positions, tilemapVisualizer)
	
	
func create_corridors(positions: Dictionary[Vector2i, bool]) -> void:
	var current_position = posicaoInicial
	
	for i in range(corridor_count):
		var corridor = ProceduralGeneration.randomwalk_corridor(current_position, corridor_length)
		if !corridor.is_empty():
			current_position = corridor.back()
			for pos in corridor:
				if !positions.has(pos):
					positions[pos] = true
		
