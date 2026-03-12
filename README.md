# Space Invasors

## 1. Game Overview
**Title:** Space Invasors  
**Genre:** 2D Space Shooter  
**Platform:** PC  
**Graphics Style:** Pixel Art  

**Description:**  
Space Invasors is a classic 2D space shooter where the player controls a spaceship to fight randomly spawning enemies and asteroids until reaching the boss. Players can collect power-ups to enhance their ship and gain points by defeating enemies and destroying asteroids.

---

## 2. Gameplay

### 2.1 Player
- **Controls:** WASD to move, Space or Left click to shoot.  
- **Health:** Maximum of 3 hearts. Player loses hearts when hit.  
- **Power-ups:**  
  - **Health:** Restores 1 heart.  
  - **Attack:** Triple shot.  
  - **Shield:** Temporary invincibility.  

### 2.2 Enemies
- **Basic Enemy:**  
  - Shoots.  
  - Health: 5.  
  - Points: 10.  

- **Shielded Enemy:**  
  - Can activate a shield for a random duration.  
  - Health: 5.  
  - Points: 20.  

- **Fast Enemy:**  
  - Moves quickly.  
  - Health: 3.  
  - Points: 30.  

- **Boss:**  
  - Appears after reaching 300 points.  
  - Health: 200. 

- **Asteroids:**  
  - Randomly spawn.
  - Health: 50. 
  - Points: 50.  

### 2.3 Scoring
- **Mechanic:** Players earn points by defeating enemies and destroying asteroids.  
- **Point system:**  
  - Basic enemy: 10 points  
  - Shield enemy: 20 points  
  - Fast enemy: 30 points  
  - Asteroids: 50 points  

### 2.4 Levels / Waves
- Enemies spawn randomly until the player reaches **300 points**, triggering the boss.  
- **No increasing difficulty per wave**, spawn is random and continuous.  

---

## 3. Game Mechanics

- **Movement:** Player moves freely within the screen boundaries.  
- **Shooting:** Player can shoot bullets using Space or Left click. Attack power-ups increase bullet count.  
- **Enemy behavior:**  
  - Basic enemy: shoots.  
  - Shield enemy: can activate temporary shields randomly.  
  - Fast enemy: moves quickly.  
- **Collision:** Player loses hearts when hit by projectiles.  
- **Death:** Player loses when all 3 hearts are gone.  
- **Boss trigger:** Reaching 300 points.  

---

## 4. Technical Details

- **Engine:** Godot  
- **Resolution:** 600x800
- **Physics:** 2D collisions and movement  

---