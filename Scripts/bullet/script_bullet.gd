extends KinematicBody2D

#VARIABLE VELOCIDAD
export (int) var speed = 750
#VARIABLE DIRECCION DE LA VELOCIDAD
var velocity = Vector2()

var bullet_damage = 0

#FUNCION QUE HACE COMENZAR LAS ACCIONES A LA BALA
func start(pos, dir,damage):
    bullet_damage = damage
    rotation = dir
    position = pos
    velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        if collision.collider.has_method("hit"):
            collision.collider.hit(bullet_damage)
        queue_free()

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()