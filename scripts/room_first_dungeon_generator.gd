@tool
extends RandomWalkGeneration

@export var min_room_width:int = 4; 
@export var min_room_height:int = 4;

@export var dungeon_width:int = 20;
@export var dungeon_height:int = 20;

@export_range(0, 10, 1) var offset: int = 1;

@export var executar_geracao: bool = false : set = _set_executar_geracao

func _set_executar_geracao(value):
	print("Chamou")
	if value:
		runProceduralGeneration()
	executar_geracao = false

func runProceduralGeneration()-> void:
	create_rooms()
	
func create_rooms() -> void:
	var rooms_list := ProceduralGeneration.binary_space_partitioning(BoundsInt.new(Vector3i(posicaoInicial.x, posicaoInicial.y, 0), Vector3i(dungeon_width, dungeon_height, 0)),
	min_room_width, min_room_height)
	
	var floor: Set = GDSet.new();
	floor = create_simple_rooms(rooms_list)
	tilemapVisualizer.paint_floor_tiles(floor.to_array())
	WallGenerator.create_walls(floor.to_dictionary(), tilemapVisualizer)


func create_simple_rooms(room_list: Array[BoundsInt])-> Set:
	var floor: Set = GDSet.new();
	
	for room in room_list:
		for col in range(offset, room.size.x - offset):
			for row in range(offset, room.size.y - offset):
				var position: Vector2i = Vector2i(room.min.x, room.min.y) + Vector2i(col, row)
				floor.add(position)
			
	return floor
