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

func binary_space_partitioning(space_split:BoundsInt, min_width:int, min_height:int) -> Array[BoundsInt]:
	var rooms_queue: Queue = GDQueue.new();
	var room_list: Array[BoundsInt] = []
	
	rooms_queue.enqueue(space_split)
	
	while(rooms_queue.size() > 0):
		var room: BoundsInt = rooms_queue.dequeue();
		
		if room.size.y >= min_height && room.size.x >= min_width:
			
			if randf() < 0.5:
				if room.size.y >= min_height * 2:
					split_horizontally(min_width, rooms_queue, room)
				elif room.size.x >= min_width * 2:
					split_vertical( min_height, rooms_queue, room)
				else:
					room_list.append(room)
			else:
				if room.size.x >= min_width * 2:
					split_vertical(min_width, rooms_queue, room)
				elif room.size.y >= min_height * 2:
					split_horizontally(min_height, rooms_queue, room)
					
				else:
					room_list.append(room)
	return room_list

func split_horizontally(min_width: int, rooms_queue: Queue, room: BoundsInt) -> void:
	var y_split = randf_range(1, room.size.y);
	
	var room1: BoundsInt = BoundsInt.new(room.min, Vector3i(room.size.x, y_split, room.size.z));
	var room2: BoundsInt =BoundsInt.new(Vector3i(room.min.x, room.min.y + y_split, room.min.z),
	Vector3i(room.size.x, room.size.y - y_split, room.size.z))
	
	rooms_queue.enqueue(room1);
	rooms_queue.enqueue(room2)
	
func split_vertical(min_height: int, rooms_queue: Queue, room: BoundsInt) -> void:
	var x_split = randf_range(1, room.size.x)
	
	var room1: BoundsInt = BoundsInt.new(room.min, Vector3i(x_split, room.min.y, room.min.z))
	var room2: BoundsInt = BoundsInt.new(Vector3i(room.min.x + x_split, room.min.y, room.min.z), 
	Vector3i(room.size.x - x_split, room.size.y, room.size.z))
	
	rooms_queue.enqueue(room1);
	rooms_queue.enqueue(room2)

func randomwalk_corridor(start_position: Vector2i, tamanho_corredor: int) -> Array[Vector2i]:
	var corredor: Array[Vector2i] = []
	var direction = Direction2D.getRandomCardinalDirection();
	var current_position = start_position
	
	for i in range (tamanho_corredor):
		current_position += direction
		corredor.append(current_position)

	return corredor
