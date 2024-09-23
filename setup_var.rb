#Sprite setup

@pixel_scaler = 1

@background_light = Sprite.new('sprites\background_light.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler
)
@background_timer = 0


@red_health_player = Sprite.new('sprites\collision_box.png',
    width: 96 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    x: 63,
    y: 28,
)

@green_health_player = Sprite.new('sprites\health.png',
    width: 96 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    x: 63,
    y: 28,
)

@red_health_enemy = Sprite.new('sprites\collision_box.png',
    width: 96 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    x: 241,
    y: 28,
)


@green_health_enemy = Sprite.new('sprites\health.png',
    width: 96 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    x: 241,
    y: 28,
)
@green_health_enemy.play flip: :horizontal

@background = Sprite.new('sprites\rooftop.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler
)







# Enemy/Player


@player_shadow = Sprite.new('sprites\player_shadow.png',
    width: 21 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    clip_width: 16,
    loop: true,
    x: 100,
    y: 200,
    z: 50,
    opacity: 0.5,
    animations: {
        biggest: 0..0,
        big: 1..1,
        small: 2..2,
        smallest: 3..3
    }  
)

@enemy_shadow = Sprite.new('sprites\player_shadow.png',
    width: 20 * @pixel_scaler,
    height: 8 * @pixel_scaler,
    clip_width: 16,
    loop: true,
    x: 300,
    y: 200,
    opacity: 0.5,
    animations: {
        biggest: 0..0,
        big: 1..1,
        small: 2..2,
        smallest: 3..3
    }  
)



@player = Sprite.new('sprites\player_sprites.png',
    clip_width: 42,
    width: 42 * @pixel_scaler,
    height: 54 * @pixel_scaler,
    x: 100,
    y: 100,
    opacity: 1,
    loop: true,
    time: 100,
    animations: {
        walk1: 0..0,
        walk2: 1..1,
        walk3: 2..2,
        walk4: 3..3,
        walk5: 4..4,
        walk6: 5..5,
        idle1: 6..6,
        idle2: 7..7,
        idle3: 8..8,
        punch1: 9..9,
        punch2: 10..10,
        punch3: 11..11,
        punch4: 12..12,
        punch5: 13..13,
        punch6: 14..14,
        jump1: 15...17,
        jump2: 18..18,
        jump3: 19...21,
        jump_kick: 22...24,
        damaged1: 25..25,
        damaged2: 26..26
    }
)

@player_collision = Sprite.new('sprites\collision_box.png',
    width: 14,
    height: 32,
    x: 100,
    y: 100,
    opacity: 0,
)

@player_hitbox = Sprite.new('sprites\collision_box.png',
    width: 8,
    height: 8,
    x: -999,
    y: -999,
    opacity: 0,
)
@player_hitbox.remove



@enemy = Sprite.new('sprites\enemy_sprites.png',
    clip_width: 34,
    width: 34,
    height: 57,
    x: 100,
    y: 100,
    opacity: 1,
    loop: true,
    time: 150,
    animations: {
        standidle1: 0...0,
        standidle2: 1...1,
        standidle3: 2...2,
        standidle4: 3...3,
        standidle5: 4...4,
        standidle6: 5...5,
        standidle7: 6...6,
        standidle9: 7...7,
        standattack1: 8..8,
        standattack2: 9..9,
        standattack3: 10..10,
        standattack4: 11..11,
        standattack5: 12..12,
        standattack6: 13..13,
        standattack7: 14..14,
        standattack8: 15..15,
        standattack9: 16..16,
        standattack10: 17..17,
        flyidle1: 18...18,
        flyidle2: 19...19,
        flyidle3: 20...20,
        flyidle4: 21...21,
        flyattack1: 22..22,
        flyattack2: 23..23,
        flyattack3: 24..24,
        flyattack4: 25..25,
        flyattack5: 26..26,
        flyattack6: 27..27,
        flyattack7: 28..28,
        flyattack8: 29..29,
        flyattack9: 30..30,
        flyattack10: 31..31,
        flyteleport1: 32..32,
        flyteleport2: 33..33,
        standteleport1: 34..34,
        standteleport2: 35..35,
        damaged1: 36..36,
        damaged2: 37..37,
        damaged3: 38..38,
        standidle8: 39..39,
    }
)
@enemy.play animation: :flyidle

@enemy_collision = Sprite.new('sprites\collision_box.png',
    width: 14,
    height: 40,
    x: 100,
    y: 100,
    opacity: 0,
)

@fadeout = Sprite.new('sprites\fadeout.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler,
    opacity: 0
)

@whitefade = Sprite.new('sprites\whitefade.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler,
    opacity: 0
)

@gameover_text = Sprite.new('sprites\gameover_text.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler,
)
@gameover_text.remove

@win_text = Sprite.new('sprites\win_text.png',
    width: 400 * @pixel_scaler,
    height: 240 * @pixel_scaler,
)
@win_text.remove

#Setup var

@player_state = nil

@player_idle_timer = 0

@left = 0
@right = 0
@x_dir = 0
@flipped = nil
@up = 0
@down = 0
@y_dir = 0
@walk_speed = 1.5 * @pixel_scaler
@walking = false
@player_walk_timer = 0

@gravity = 0.25
@player_jump_velocity = 0
@jumping = false
@player_dfg = 0

@enemy_jump_velocity = 0
@enemy_dfg = 0

@dash_timeframe = 10
@first_dash_press = nil
@dashing = false
@dash_speed = 3.0
@dash_timer = 15
@dash_incrementor = 0

@attacking = false
@player_attack_timer = 0

@damaged = false
@damage_timer = 0

@player_lost = false

@i_frames = 0

#Enemy

@enemy_dfg = 30
@float_timer = 0
@enemy_attack_state = 0
@enemy_attack_timer = 0
@enemy_flipped = nil
@enemy_damaged = false
@enemy_damage_timer = 0
@enemy_jump_velocity = 0
@enemy_idle_timer = 400
@enemy_loop = 0

@fireball_counter = 0
@fireball_array = []
@fireball_dir_array = []

@boss_ragemode = false
@enemy_lose = false

#helpfunktion för animation: man kan sätta dom efter varandra i koden och de är aktiva för hur många frames som man läggger in och spelas upp direkt efter varandra:
#animate(punch1, 30)
#animate(punch2, 14) <- fixar flip själv. kan även ge ett värde när animationen är över
#animate(punch3, 25)