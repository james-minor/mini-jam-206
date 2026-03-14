
# Game Summary

The player is a cowboy in a top-down dungeon map (like The Binding of Isaac or Cult of the Lamb).
Goal of the game is to clear 4 floors, finding the level exit on each floor.

# Floor tiles

Over time floor tiles in each room will turn into pits, these pits will instantly kill
the player or any enemies that go over them. These pits will persist between room transitions.

# Lasso Controls

The player can use **Mouse 1** to pull an enemy towards the player. Once the
enemy is pulled to the player, players can aim with the mouse and press
**Space** to punch an enemy in a chosen direction.

The player can use **Mouse 2** to pull themselves onto an enemy. Once contact is
made the enemy will be punched in the direction vector between the player's origin
position and the enemy's position.

**Mouse 1** or **Mouse 2** can be used by the player to pull themselves onto a 
cacti.

# Player weapons

The player can carry one weapon in addition to their lasso. These weapons can be
used with the **Space** key. Weapons may be found randomly throughout the game world.

## Bottle - zp

The player can throw a relatively slow moving bottle that does significant damage.

## Dynamite - zp

Area of effect weapon

## Playing cards - zp

Ranged weapon that does okay damage, the player throws three of them at once in a 
scattered pattern

## Dungeon Generation - zp

Prefabbed rooms should be selected at random when a user enters a room. These 
should be persistent. 
Data structure for paths between rooms with an api to get 
