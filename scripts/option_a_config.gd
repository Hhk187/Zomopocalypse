extends Node
## Option A Configuration
## This config enables a more relaxed gameplay mode with reduced zombie threat.
## 
## To enable Option A, set OPTION_A_ENABLED to true.
## To disable Option A, set OPTION_A_ENABLED to false.
##
## Option A changes:
## - Reduced zombie spawn frequency (increased spawn delay)
## - Lower maximum concurrent zombies
## - Reduced AI detection radius
## - Simplified pathfinding for less aggressive behavior

class_name OptionAConfig

# Enable or disable Option A globally
const OPTION_A_ENABLED: bool = true

# Zombie spawn settings
const ZOMBIE_SPAWN_DELAY_SECONDS: float = 10.0  # Increased from default 3.0
const MAX_CONCURRENT_ZOMBIES: int = 5  # Reduced from default 15
const SPAWN_DISTANCE_FROM_PLAYER: float = 30.0  # Minimum distance to spawn zombies

# AI behavior settings
const AI_DETECTION_RADIUS: float = 8.0  # Reduced from default 15.0
const AI_CHASE_SPEED_MULTIPLIER: float = 0.7  # 70% of normal speed
const AI_PATHFINDING_UPDATE_DELAY: float = 1.0  # Increased delay between path updates

# Combat settings
const ZOMBIE_DAMAGE_MULTIPLIER: float = 0.75  # 75% damage
const ZOMBIE_HEALTH_MULTIPLIER: float = 0.8  # 80% health
