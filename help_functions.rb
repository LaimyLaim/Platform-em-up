def gravity(gravity, distance_from_ground, y_velocity)
    y_velocity = (y_velocity - gravity)
    if (distance_from_ground + y_velocity) > 0
        distance_from_ground = (distance_from_ground + y_velocity)
        return [distance_from_ground, y_velocity]
    else
        y_velocity = 0
        distance_from_ground = 0
        return [distance_from_ground, y_velocity]
    end
end

def collision(object_1, object_1_distance_from_ground, object_1_shadow, object_2, object_2_distance_from_ground, object_2_shadow)
    if object_2_shadow.y + object_2_shadow.height > object_1_shadow.y && object_2_shadow.y < object_1_shadow.y + object_1_shadow.height
        # if  object_2_shadow.x + object_2_shadow.width > object_1_shadow.x && object_2_shadow.x < object_1_shadow.x + object_1_shadow.width
            if object_2.y + object_2.height > object_1.y && object_2.y < object_1.y + object_1.height
                if  object_2.x + object_2.width > object_1.x && object_2.x < object_1.x + object_1.width
                    if object_2.x > object_1.x
                        return "right"
                    else
                        return "left"
                    end
                end
            end
        # end
    end
    return false
end

def firaball_placement(enemy_state, flipped)
    if enemy_state == 1
        if flipped == nil
            dir = -1
        else
            dir = 1
        end
        return [
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
        ]
    elsif enemy_state == 2
        if flipped == nil
            dir = -2
            x_placement = 420
            y_placement = 0
        else
            dir = 2
            x_placement = -20
            y_placement = 5
        end
        return [
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 9*(dir/(dir).abs),
            y: 80 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 9*(dir/(dir).abs),
            y: 80 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 6*(dir/(dir).abs),
            y: 100 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 6*(dir/(dir).abs),
            y: 100 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 3*(dir/(dir).abs),
            y: 120 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 3*(dir/(dir).abs),
            y: 120 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement,
            y: 140 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement,
            y: 140 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement,
            y: 160 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement,
            y: 160 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 3*(dir/(dir).abs),
            y: 180 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 3*(dir/(dir).abs),
            y: 180 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 6*(dir/(dir).abs),
            y: 200 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 6*(dir/(dir).abs),
            y: 200 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ],
        [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement - 9*(dir/(dir).abs),
            y: 220 + y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement - 9*(dir/(dir).abs),
            y: 220 + y_placement,
            loop: true,
            time: 100
            ), 
            flipped, 
            dir * 3,
            10,
            0,
            0
        ]
        ]
    elsif enemy_state == 3 
        # Falling fire
        # implementera också second phase = en fireball blir till en row, attack 2 blir snabbare och kanske även från höger och vänster. båda sidorna
        x_placement = rand(20...380)
        y_placement = rand(80...220)
        return [
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: x_placement,
            y: y_placement,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: x_placement,
            y: y_placement,
            loop: true,
            time: 100,
            rotate: -90
            ), 
            nil, 
            0,
            200,
            2,
            0
            ]

        ]
    elsif enemy_state == 4
        if flipped == nil
            dir = -1
        else
            dir = 1
        end
        return [
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x - 4*dir,
            y: @enemy_shadow.y - 24,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x - 4*dir,
            y: @enemy_shadow.y - 24,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y - 16,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y - 16,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x + 4*dir,
            y: @enemy_shadow.y - 8,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x + 4*dir,
            y: @enemy_shadow.y - 8,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x + 8*dir,
            y: @enemy_shadow.y,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x + 8*dir,
            y: @enemy_shadow.y,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x + 4*dir,
            y: @enemy_shadow.y + 8,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x + 4*dir,
            y: @enemy_shadow.y + 8,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y + 16,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x,
            y: @enemy_shadow.y + 16,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ],
            [
            Sprite.new('sprites\player_shadow.png',
            clip_width: 16,
            width: 16,
            height: 8,
            x: @enemy_shadow.x - 4*dir,
            y: @enemy_shadow.y + 24,
            loop: true,
            time: 100,
            opacity: 0.8,
            animations: {
            biggest: 0..0,
            big: 1..1,
            small: 2..2,
            smallest: 3..3
            }  
            ),
            Sprite.new('sprites\fireball1.png',
            clip_width: 16,
            width: 16,
            height: 16,
            x: @enemy_shadow.x - 4*dir,
            y: @enemy_shadow.y + 24,
            loop: true,
            time: 100
            ), 
            flipped, 
            3 * dir,
            45,
            0,
            0
            ]
        ]
    end
end

