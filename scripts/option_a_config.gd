extends Node
## Option A Configuration
## This config provides gameplay constants for Option A - a more relaxed gameplay mode.
## To check if Option A is enabled, reference Global.OPTION_A_ENABLED
##
## Option A changes:
## - Reduced zombie spawn frequency (increased spawn delay)
## - Lower maximum concurrent zombies
## - Reduced AI detection radius
## - Simplified pathfinding for less aggressive behavior

class_name OptionAConfig

# Zombie spawn settings (used when Global.OPTION_A_ENABLED is true)
const ZOMBIE_SPAWN_DELAY_SECONDS: float = 10.0  # Increased from default 3.0
const MAX_CONCURRENT_ZOMBIES: int = 5  # Reduced from default 15
const SPAWN_DISTANCE_FROM_PLAYER: float = 30.0  # Minimum distance to spawn zombies

# AI behavior settings (used when Global.OPTION_A_ENABLED is true)
const AI_DETECTION_RADIUS: float = 8.0  # Reduced from default 15.0
const AI_CHASE_SPEED_MULTIPLIER: float = 0.7  # 70% of normal speed
const AI_PATHFINDING_UPDATE_DELAY: float = 1.0  # Increased delay between path updates

# Combat settings (used when Global.OPTION_A_ENABLED is true)
const ZOMBIE_DAMAGE_MULTIPLIER: float = 0.75  # 75% damage
const ZOMBIE_HEALTH_MULTIPLIER: float = 0.8  # 80% health
