extends Node3D

# Размеры лабиринта
var width = 21
var height = 21
var wallHeight = 2
var corridor = 2

# Список направлений (право, вниз, лево, верх)
var directions = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]

# Массив для хранения стены или прохода
var maze = Array()

# Начальная позиция алгоритма
var start_x = 1
var start_y = 1


func _ready():
	# Инициализация массива лабиринта
	for i in range(height):
		var row = []
		for j in range(width):
			row.append(1)  # Заполняем стенами (1)
		maze.append(row)

	# Создаем начальную точку как проход (0)
	maze[start_y][start_x] = 0

	# Генерация лабиринта
	carve_passages_from(start_x, start_y)

	# Создание лабиринта в сцене
	build_maze()


func carve_passages_from(cx, cy):
	# Перемешиваем направления для случайности
	directions.shuffle()

	for direction in directions:
		var nx = cx + direction.x * 2
		var ny = cy + direction.y * 2

		if nx > 0 and nx < width - 1 and ny > 0 and ny < height - 1 and maze[ny][nx] == 1:
			maze[cy + direction.y][cx + direction.x] = 0  # Создаем проход
			maze[ny][nx] = 0  # Создаем проход
			carve_passages_from(nx, ny)


func build_maze():
	for y in range(height):
		for x in range(width):
			if maze[y][x] == 1:
				var wall = Node3D.new()

				# --- ИЗМЕНЕНИЕ 1: CollisionShape3D теперь имеет меньшую высоту (0.5 вместо wallHeight) ---
				var box_shape = BoxShape3D.new()
				box_shape.extents = Vector3(2 * corridor, wallHeight, 2 * corridor)  # Было: Vector3(0.5, wallHeight, 0.5)

				var collision_shape = CollisionShape3D.new()
				collision_shape.shape = box_shape
				wall.add_child(collision_shape)

				var box_mesh = MeshInstance3D.new()
				var box_mesh_resource = BoxMesh.new()
				box_mesh_resource.size = Vector3(1.0 * corridor, wallHeight, 1.0 * corridor)
				box_mesh.mesh = box_mesh_resource
				wall.add_child(box_mesh)

				wall.transform.origin = Vector3(x * corridor, 0, y * corridor)  # Увеличиваем расстояние в 2 раза
				add_child(wall)
