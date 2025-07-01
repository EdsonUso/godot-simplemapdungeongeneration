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
	var potential_room_positions: Dictionary[Vector2i, bool] = {}
	
	var corridors = create_corridors(floor_positions, potential_room_positions)
	var room_positions: Dictionary[Vector2i, bool] = create_rooms(potential_room_positions)
	var dead_ends: Array[Vector2i] = findall_deadends(floor_positions)
	
	create_rooms_at_dead_end(dead_ends, room_positions)
	floor_positions.merge(room_positions, false)
	
	for i in range(corridors.size()):
		corridors[i] = aumentar_tamanho_cubico(corridors[i])
		floor_positions.merge(_convert_array_to_dictionary(corridors[i]), true)
	
	
	tilemapVisualizer.limpar_piso()
	tilemapVisualizer.paint_floor_tiles(floor_positions.keys())
	WallGenerator.create_walls(floor_positions, tilemapVisualizer)


func aumentar_tamanho_cubico(corridor: Array[Vector2i]) -> Array[Vector2i]:
	var new_corridor: Array[Vector2i] = []
	
	for i in range (corridor.size()):
		for x in range(-1, 2):
			for y in range(-1, 2):
				new_corridor.append(corridor[i - 1] + Vector2i(x,y))
	
	return new_corridor	



func aumentar_tamanho(corridor: Array[Vector2i]) -> Array[Vector2i]:
	var new_corridor: Array[Vector2i] = []
	var preview_direction := Vector2i.ZERO
	
	for i in range(corridor.size()):
		var direcao_celula := corridor[i] - corridor[i - 1]
		
		if preview_direction != Vector2i.ZERO and direcao_celula != preview_direction:
			
			for x in range(-1, 2):
				for y in range(-1, 2):
					new_corridor.append(corridor[i - 1] + Vector2i(x,y))
					
			preview_direction = direcao_celula
		else:
			var new_corridor_offset = get_direction_from(direcao_celula)
			new_corridor.append(corridor[i - 1])
			new_corridor.append(corridor[i - 1] + new_corridor_offset)
	
	return new_corridor
	


func get_direction_from(direction: Vector2i) -> Vector2i:
	if direction.x != 0:
		if direction.x > 0: # Moving Right
			return Vector2i.DOWN # Next is Down
		else: # Moving Left
			return Vector2i.UP # Next is Up
	elif direction.y != 0:
		if direction.y > 0: # Moving Down
			return Vector2i.LEFT # Next is Left
		else: # Moving Up
			return Vector2i.RIGHT # Next is Right
	return Vector2i.ZERO # Should not happen with valid cardinal directions

func create_rooms_at_dead_end(dead_ends: Array[Vector2i], room_floors: Dictionary[Vector2i, bool]) -> void:
	
	for position in dead_ends:
		if not room_floors.has(position): 
			var room := runRandomWalk(random_walk_parameters, position)
			room_floors.merge(room, false)
			


func findall_deadends(floor_positions: Dictionary[Vector2i, bool]) -> Array[Vector2i]:
	
	var dead_ends: Array[Vector2i] = []
	
	for position in floor_positions:
		var neighboors_count := 0
		for direction in Direction2D.direcoesCardinais:
			
			if floor_positions.has(position + direction):
				neighboors_count += 1
		
		if neighboors_count == 1:
			dead_ends.append(position)
	
	return dead_ends

func create_corridors(positions: Dictionary[Vector2i, bool], potential_room_positions: Dictionary[Vector2i, bool]):
	var current_position = posicaoInicial
	potential_room_positions[current_position] = true;
	var corridors = []
	
	for i in range(corridor_count):
		var corridor = ProceduralGeneration.randomwalk_corridor(current_position, corridor_length)
		corridors.append(corridor)
		if not corridor.is_empty():
			current_position = corridor.back()
			potential_room_positions[current_position] = true;
			
			var corridor_dict: Dictionary[Vector2i, bool] = {}
			for pos in corridor:
				corridor_dict[pos] = true
				
			positions.merge(corridor_dict, false)
			
	return corridors

func create_rooms(potential_room_positions: Dictionary[Vector2i, bool]):
	var room_positions: Dictionary[Vector2i, bool] = {}
	var room_to_create_count:int = round(potential_room_positions.size() * room_percent)
	
	var room_positions_list = potential_room_positions.keys()
	room_positions_list.shuffle()
	var room_to_create = room_positions_list.slice(0, room_to_create_count)
	
	for room_position in room_to_create :
		var room_floor := runRandomWalk(random_walk_parameters, room_position)
		room_positions.merge(room_floor, false)
		
	return room_positions

func _convert_array_to_dictionary(array: Array[Vector2i]) -> Dictionary[Vector2i, bool]:
	var dict: Dictionary[Vector2i, bool] = {}
	for item in array:
		dict[item] = true
	return dict
	
	
	
	
