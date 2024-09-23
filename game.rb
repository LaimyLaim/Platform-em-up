require 'ruby2d'
require_relative "setup_var.rb"
require_relative "help_functions.rb"

sleep(1)

set width: 400 * @pixel_scaler
set height: 240 * @pixel_scaler
set resizable: true
set fullscreen: true

on :key_down do |event|
    if @gameover_text.z == @fadeout.z + 1 || @win_text.z == 999
        exit
    end
end

on :key_held do |event|
    case event.key
        when 'd'
            if @damaged == false && @enemy_lose == false
                @x_dir = 1
                @right = 1
                if @left != 1 && @attacking == false
                    @flipped = nil
                end
            end
        when 'a'
            if @damaged == false && @enemy_lose == false
                @x_dir = -1
                @left = 1
                if @right != 1 && @attacking == false
                    @flipped = "horizontal"
                end
            end
        when 'w'
            if @damaged == false && @enemy_lose == false
                @y_dir = -1
                @up = 1
            end
        when 's'
            if @damaged == false && @enemy_lose == false
                @y_dir = 1
                @down = 1
            end
    end     
end

on :key_down do |event|
    case event.key
        when 'p'
            if @jumping == false && @attacking == false && @damaged == false && @enemy_lose == false
                @player_jump_velocity = 6
                @jumping = true
            end
        when 'o'
            if @attacking == false && @damaged == false && @enemy_lose == false
                @attacking = true
                @player_attack_timer = 0
            end
    end     
end

on :key_up do |event|
    case event.key
        when 'd'
            if @enemy_lose == false
                @right = 0
            end
        when 'a'
            if @enemy_lose == false
                @left = 0
            end
        when 'w'
            if @enemy_lose == false
                @up = 0
            end
        when 's'
            if @enemy_lose == false
                @down = 0
            end
        when 'p'
            if @enemy_lose == false && @damaged == false
                if @player_jump_velocity > 1 
                    @player_jump_velocity = 1
                end
            end
    end     
end


# text = Text.new(
#     @player_collision.y,
#     x: 20, y: 20,
#     style: 'bold',
#     size: 20,
#     color: 'blue',
# )


update do

    if @damaged != true
        @player.rotate = 0
    end

    # if @first_dash_press != nil
    #     @dash_incrementor -= 1
    #     if @dash_incrementor == 0
    #         @first_dash_press = nil
    #     end
    # end

    if (@right - @left) != 0 && (@down - @up) != 0
        @x_dir = (@right - @left) * 0.70 # typ roten ur 2 dividerat på 2
        @y_dir = (@down - @up) * 0.70 
    else
        @x_dir = (@right - @left) 
        @y_dir = (@down - @up)
    end 

    if @x_dir != 0 || @y_dir != 0
        @walking = true
    else
        @walking = false
    end

    # if @dashing
    #     player_speed = @dash_speed
    #     @dash_incrementor -= 1
    #     if @dash_incrementor <= 0
    #         if @player_dfg == 0
    #             @dashing = false
    #         end
    #     end
    # else
    #     player_speed = @walk_speed
    # end  
    player_speed = @walk_speed

    player_shadow_ground = (@player_shadow.y + 5) #Behöver förmodligen ändra här sen
    player_jumparc_array = gravity(@gravity, @player_dfg, @player_jump_velocity)
    @player_dfg = player_jumparc_array[0]
    @player_jump_velocity = player_jumparc_array[1]
    if @player_dfg == 0
        if @jumping
            @attacking = false
            @player_hitbox.remove
            @player_hitbox.x = -999
            @player_hitbox.y = -999
        end
        @jumping = false
    end 



    # -----------------------------------------------------------------------------------------------------------------------------------------------

    enemy_shadow_ground = (@enemy_shadow.y + 8)
    player_jumparc_array = gravity(0, @enemy_dfg, @enemy_jump_velocity)
    @enemy_dfg = player_jumparc_array[0]

    # @enemy_dfg = 40 + 5 * Math.sin(0.05*@float_timer)
    @float_timer += 5 

    if @enemy_dfg > 0
        temp_dfg = @enemy_dfg + 2 * Math.sin(0.01*@float_timer)
    else
        temp_dfg = @enemy_dfg
    end

    @enemy.y = (enemy_shadow_ground - @enemy.height) - temp_dfg

    if temp_dfg > 60
        @enemy_shadow.play animation: :smallest
    elsif temp_dfg > 40
        @enemy_shadow.play animation: :small
    elsif temp_dfg > 20
        @enemy_shadow.play animation: :big
    else
        @enemy_shadow.play animation: :biggest
    end
    
    if @enemy_damaged
        if @enemy_damage_timer == 0
            @enemy_jump_velocity = 2
            @new_health_value_enemy = @green_health_enemy.width - 6 #vit txt variable är bara aktiv i 1 "frame loop". sedan blir den nil
            if @new_health_value_enemy <= 48
                @boss_ragemode = true
            end
            @enemy_attack_timer = 0
        end
        if @enemy_damage_timer <= 5
            if @enemy_flipped == nil
                @enemy_shadow.x += 4
            else
                @enemy_shadow.x -= 4
            end
        end
        @enemy.play animation: :damaged1, flip: :"#{@enemy_flipped}"

        @enemy_collision.x = @enemy_shadow.x
        @enemy.y = @enemy_collision.y 
       
        if @green_health_enemy.width > @new_health_value_enemy
            @green_health_enemy.width -= 2
        end

        if @enemy_damage_timer > 5 && @enemy_damage_timer <= 10
            @enemy_jump_velocity = 0
            @enemy.play animation: :damaged2, flip: :"#{@enemy_flipped}"
        elsif @enemy_damage_timer <= 15
            @enemy.play animation: :damaged3, flip: :"#{@enemy_flipped}"
        elsif @enemy_damage_timer <= 20
            @enemy_shadow.x = 999
        elsif @enemy_damage_timer > 20
            @enemy_damaged = false
            @enemy_damage_timer = -1
            @enemy_dfg = 45
            if @new_health_value_enemy <= 0
                @enemy_lose = true
            else
                @enemy_attack_state = rand(1...4)
                if @enemy_attack_state == 1
                    @enemy_loop = rand(5..8)
                elsif @enemy_attack_state == 2
                    @enemy_loop = rand(2..5)
                elsif @enemy_attack_state == 3
                    @enemy_loop = rand(10..20)
                end
            end
        end 
        @enemy_damage_timer += 1
    elsif @enemy_lose
        
        if @enemy_attack_timer == 0
            @enemy_shadow.x = Window.width/2 - @enemy.width/2
            @enemy_shadow.y = Window.height/2 + 50
            @frame_incrementor = 40
            @x_dir = 0
            @y_dir = 0
            @right = 0
            @left = 0
            @up = 0
            @down = 0
        end
        if @enemy_attack_timer <= 4
            @enemy.play animation: :damaged3, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 8
            @enemy.play animation: :damaged2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 20
            @enemy.play animation: :damaged1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 26
            @enemy.play animation: :damaged2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 26 + @frame_incrementor
            @enemy.play animation: :damaged1, flip: :"#{@enemy_flipped}"
            if @enemy_attack_timer == 26 + @frame_incrementor
                @enemy_attack_timer = 20
                if @frame_incrementor - 5 > 0
                    @frame_incrementor -= 5
                else
                    @frame_incrementor = 1
                end
            end
        end
        if @enemy_attack_timer >= 20
            @whitefade.z = 999
            if @whitefade.color.opacity < 1 && @enemy_shadow.x != 999
                @whitefade.color.opacity += 0.003 
            elsif @enemy_shadow.x == 999 && @whitefade.color.opacity > 0
                @whitefade.color.opacity -= 0.05
            elsif @whitefade.color.opacity >= 1 && @enemy_shadow.x != 999
                @enemy_shadow.x = 999
                @fadeout.add
                @fadeout.color.opacity = 1
                @fadeout.z = 997
                @player_shadow.z = 998
            elsif @whitefade.color.opacity <= 0 && @enemy_shadow.x == 999
                if @player_shadow.x != Window.width/2 - @player_shadow.width/2
                    if @player_shadow.x > Window.width/2 - @player_shadow.width/2
                        if @player_shadow.x - 1.5 < Window.width/2 - @player_shadow.width/2
                            @player_shadow.x = Window.width/2 - @player_shadow.width/2
                            @x_dir = 0
                            @right = 0
                        else
                            @flipped = "horizontal"
                            @x_dir = -1
                            @left = 1
                        end
                    elsif @player_shadow.x < Window.width/2 - @player_shadow.width/2
                        if @player_shadow.x + 1.5 > Window.width/2 - @player_shadow.width/2
                            @player_shadow.x = Window.width/2 - @player_shadow.width/2
                            @x_dir = 0
                            @right = 0
                        else
                            @flipped = nil
                            @x_dir = 1
                            @right = 1
                        end
                    end
                else
                    if @player_jump_velocity == 0 && @gravity != 0
                        @player_jump_velocity = 6
                        @jumping = true
                    elsif @player_jump_velocity < 1
                        @player_jump_velocity = 0
                        @gravity = 0
                        @win_text.z = 999
                        @win_text.add
                    end
                end
            end
        end

        @enemy_attack_timer += 1


    elsif @enemy_attack_state == 0
        if @enemy_attack_timer <= 4
            if @enemy_dfg != 0
                @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standattack1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 8
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 12
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport2, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 20
            @enemy_shadow.x = 999
            @enemy_shadow.y = 0
            if rand(2) == 1
                @enemy_dfg = 0
            else
                @enemy_dfg = 50
            end
        elsif @enemy_attack_timer > 20
            if @enemy_attack_timer == 21
                @enemy_shadow.x = rand(50..350)
                @enemy_shadow.y = rand(100..200)
                if @enemy_shadow.x < @player_shadow.x 
                    @enemy_flipped = "horizontal"
                else
                    @enemy_flipped = nil
                end               
            end
            if @enemy_dfg == 0
                if @enemy_attack_timer <= 28
                    @enemy.play animation: :standidle1, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 36
                    @enemy.play animation: :standidle2, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 44
                    @enemy.play animation: :standidle3, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 52
                    @enemy.play animation: :standidle4, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 60
                    @enemy.play animation: :standidle5, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 68
                    @enemy.play animation: :standidle6, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 76
                    @enemy.play animation: :standidle7, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 84
                    @enemy.play animation: :standidle8, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 92
                    @enemy.play animation: :standidle7, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 100
                    @enemy.play animation: :standidle8, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 108
                    @enemy.play animation: :standidle7, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 116
                    @enemy.play animation: :standidle8, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 124
                    @enemy.play animation: :standidle7, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 132
                    @enemy.play animation: :standidle8, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 140
                    @enemy.play animation: :standidle7, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 148
                    @enemy.play animation: :standidle9, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer > 148
                    @enemy.play animation: :standidle1, flip: :"#{@enemy_flipped}"
                    if @enemy_idle_timer != 0
                        @enemy_attack_timer = 22
                    end 
                end
            else
                if @enemy_attack_timer <= 32
                    @enemy.play animation: :flyidle1, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 44
                    @enemy.play animation: :flyidle2, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 56
                    @enemy.play animation: :flyidle3, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer <= 68
                    @enemy.play animation: :flyidle4, flip: :"#{@enemy_flipped}"
                elsif @enemy_attack_timer > 68
                    @enemy.play animation: :flyidle1, flip: :"#{@enemy_flipped}"
                    if @enemy_idle_timer != 0
                        @enemy_attack_timer = 22
                    end 
                end
            end
        end
        @enemy_attack_timer += 1
        @enemy_idle_timer -= 1
        if @enemy_idle_timer < 0
            @enemy_attack_timer = 0
            @enemy_attack_state = rand(1...4)
            if @enemy_attack_state == 1
                @enemy_loop = rand(5..8)
            elsif @enemy_attack_state == 2
                @enemy_loop = rand(2..5)
            elsif @enemy_attack_state == 3
                @enemy_loop = rand(10..20)
            end

        end
    elsif @enemy_attack_state == 1
        if @enemy_attack_timer <= 4
            if @enemy_dfg != 0
                @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standattack1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 8
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 12
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport2, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 20
            @enemy_shadow.x = 999
            @enemy_shadow.y = 0
            @enemy_dfg = 0
        elsif @enemy_attack_timer <= 24
            if @enemy_attack_timer == 21
                if @player_shadow.x - 100 > 0 && @player_shadow.x + 100 < Window.width
                    if rand(2) == 1
                        @enemy_shadow.x = @player_shadow.x + 100
                        @enemy_flipped = nil
                    else
                        @enemy_shadow.x = @player_shadow.x - 100
                        @enemy_flipped = "horizontal"
                    end
                elsif @player_shadow.x - 100 > 0
                    @enemy_shadow.x = @player_shadow.x - 100
                    @enemy_flipped = "horizontal"
                elsif @player_shadow.x + 100 < Window.width
                    @enemy_shadow.x = @player_shadow.x + 100
                    @enemy_flipped = nil
                end
                @enemy_shadow.y = @player_shadow.y
            end
            @enemy.play animation: :standteleport2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 28
            @enemy.play animation: :standteleport1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 32
            @enemy.play animation: :standattack1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 44
            @enemy.play animation: :standattack2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 48
            if @enemy_attack_timer == 45
                if @boss_ragemode == false
                    @fireball_array += firaball_placement(@enemy_attack_state, @enemy_flipped)
                elsif @boss_ragemode
                    @fireball_array += firaball_placement(4, @enemy_flipped)
                end
            end      
            @enemy.play animation: :standattack3, flip: :"#{@enemy_flipped}"          
        elsif @enemy_attack_timer <= 52
            @enemy.play animation: :standattack4, flip: :"#{@enemy_flipped}"
            if @boss_ragemode
                @enemy_attack_timer = 60
            end
        elsif @enemy_attack_timer <= 56
            @enemy.play animation: :standattack5, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 60
            @enemy.play animation: :standattack6, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer > 60
            if @enemy_loop > 1
                @enemy_attack_timer = 0
            else
                @enemy_attack_state = 0
                if @boss_ragemode
                    @enemy_idle_timer = rand(100..150)
                else
                    @enemy_idle_timer = rand(150..300)
                end
                @enemy_attack_timer = -1
            end
            @enemy_loop -= 1
        end
        @enemy_attack_timer += 1

    elsif @enemy_attack_state == 2

        if @enemy_attack_timer <= 4
            if @enemy_dfg != 0
                @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standattack1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 8
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 12
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport2, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 20
            @enemy_shadow.x = 999
            @enemy_shadow.y = 0
            @enemy_dfg = 50
        elsif @enemy_attack_timer <= 24
            if @enemy_attack_timer == 21
                if rand(2) == 1
                    @enemy_shadow.x = 350
                    @enemy_flipped = nil
                else
                    @enemy_shadow.x = 50
                    @enemy_flipped = "horizontal"
                end
                @enemy_shadow.y = rand(100..200)
            end
            @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 28
            @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 32
            @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 44
            @enemy.play animation: :flyattack2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 48
            @enemy.play animation: :flyattack3, flip: :"#{@enemy_flipped}"
            if @enemy_attack_timer == 45
                if @boss_ragemode
                    @fireball_array += firaball_placement(@enemy_attack_state, nil)
                    @fireball_array += firaball_placement(@enemy_attack_state, "horizontal")
                else
                    @fireball_array += firaball_placement(@enemy_attack_state, @enemy_flipped)
                end
            end
        elsif @enemy_attack_timer <= 52
            @enemy.play animation: :flyattack7, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 56
            @enemy.play animation: :flyattack8, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 60
            @enemy.play animation: :flyattack9, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 64
            @enemy.play animation: :flyattack10, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer > 64 && @fireball_array.length > 0 && @boss_ragemode == false # KAN TA BORT OM MAN VILL HA SVÅRARE?
            @enemy_attack_timer = 48
        else
            if @enemy_loop > 1
                @enemy_attack_timer = 0
            else
                @enemy_attack_state = 0
                if @boss_ragemode
                    @enemy_idle_timer = rand(100..150)
                else
                    @enemy_idle_timer = rand(150..300)
                end
                @enemy_attack_timer = -1
            end
            @enemy_loop -= 1
        end
        @enemy_attack_timer += 1
    elsif @enemy_attack_state == 3
        if @enemy_attack_timer <= 4
            if @enemy_dfg != 0
                @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standattack1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 8
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport1, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 12
            if @enemy_dfg != 0
                @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
            else
                @enemy.play animation: :standteleport2, flip: :"#{@enemy_flipped}"
            end
        elsif @enemy_attack_timer <= 20
            @enemy_shadow.x = 999
            @enemy_shadow.y = 0
            @enemy_dfg = 50
        elsif @enemy_attack_timer <= 24
            if @enemy_attack_timer == 21
                if rand(2) == 1
                    @enemy_shadow.x = 350
                    @enemy_flipped = nil
                else
                    @enemy_shadow.x = 50
                    @enemy_flipped = "horizontal"
                end
                @enemy_shadow.y = rand(100..200)
            end
            @enemy.play animation: :flyteleport2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 28
            @enemy.play animation: :flyteleport1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 32
            @enemy.play animation: :flyattack1, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 44
            @enemy.play animation: :flyattack2, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 48
            @enemy.play animation: :flyattack3, flip: :"#{@enemy_flipped}"
            if @enemy_attack_timer == 45
                if @boss_ragemode
                    i = 0
                    while i < 5
                        @fireball_array += firaball_placement(@enemy_attack_state, @enemy_flipped)
                        i += 1
                    end
                else
                    @fireball_array += firaball_placement(@enemy_attack_state, @enemy_flipped)
                end
            end
        elsif @enemy_attack_timer <= 52
            @enemy.play animation: :flyattack3, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 56
            @enemy.play animation: :flyattack4, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 60
            @enemy.play animation: :flyattack5, flip: :"#{@enemy_flipped}"
        elsif @enemy_attack_timer <= 64
            @enemy.play animation: :flyattack6, flip: :"#{@enemy_flipped}"
        else
            if @enemy_loop > 1
                @enemy_attack_timer = 44
            else
                @enemy_attack_state = 0
                if @boss_ragemode
                    @enemy_idle_timer = rand(100..150)
                else
                    @enemy_idle_timer = rand(150..300)
                end
                @enemy_attack_timer = -1
            end
            @enemy_loop -= 1
        end
        @enemy_attack_timer += 1
    end

    if @enemy_flipped == nil
        @enemy.x = (@enemy_shadow.x - 12)
    else
        @enemy.x = (@enemy_shadow.x - 2)
    end
    @enemy_collision.x = @enemy_shadow.x + @enemy_shadow.width/2 - @enemy_collision.width/2
    @enemy_collision.y = @enemy_shadow.y - @enemy_dfg - @enemy_collision.height - 7
    
    # -----------------------------------------------------------------------------------------------------------------------------------------------






    # Draw on screen -------------------------------------------------------------------------------------------------------------------------------

    @player_collision.y = (player_shadow_ground - @player_collision.height) - @player_dfg

    if @player_dfg > 60
        @player_shadow.play animation: :smallest
    elsif @player_dfg > 40
        @player_shadow.play animation: :small
    elsif @player_dfg > 20
        @player_shadow.play animation: :big
    else
        @player_shadow.play animation: :biggest #Ändra så att det är större när man hoppar?? Ändrar gamefeel?
    end

    if @attacking == false || @jumping == true
        @player_shadow.x += @x_dir * player_speed
        @player_shadow.y += @y_dir * player_speed * 0.8 #Perspective
    end

    if @damaged
        if @damage_timer == 0
            @player_jump_velocity = 4
            @up = 0
            @down = 0
            @left = 0
            @right = 0
            @attacking = false
            @player_hitbox.remove
            @player_hitbox.x = -999
            @player_hitbox.y = -999
            @jumping = false
            @new_health_value = @green_health_player.width - 16
        end
        if @green_health_player.width > @new_health_value
            @green_health_player.width -= 2
        end
        if @player_dfg != 0 || @player_jump_velocity > 0
            if @flipped == nil
                @player_shadow.x -= 2
                @player.rotate -= 2
                @player_collision.x = @player_shadow.x
                @player.x = @player_collision.x
            else
                @player_shadow.x += 2
                @player.rotate += 2
                @player_collision.x = @player_shadow.x
                @player.x = @player_collision.x - 20
            end
            @player.play animation: :damaged1, flip: :"#{@flipped}"
        else
            if @flipped == nil
                @player.rotate = 270
                @player.x = @player_collision.x - 10
            else
                @player.rotate = 90
                @player.x = @player_collision.x - 10
            end
            @player.play animation: :damaged2, flip: :"#{@flipped}"

            @player_collision.x = @player_shadow.x
            

        end
        @player.y = @player_collision.y 

        if @new_health_value == 0
            if @fadeout.color.opacity == 0
                sleep(0.5)
            end
            sleep(0.02)
            @player_lost = true
            @fadeout.z = 999
            @player_shadow.z = @fadeout.z + 1
            @fadeout.color.opacity = 1
        end


        if @damage_timer > 60 && @new_health_value > 0
            @damaged = false
            @damage_timer = -1
            @i_frames = 30
        elsif @damage_timer > 56 && @new_health_value <= 0
            @gameover_text.add
            @gameover_text.z = @fadeout.z + 1
        end
        @damage_timer += 1

    elsif @attacking
        
        @player_collision.width = 13
        @player_collision.height = 50   
        
        if @flipped == nil    
            @player_collision.x = (@player_shadow.x + @player_shadow.width/2 - @player_collision.width/2) + 2
            @player.x = @player_collision.x - 8
        else
            @player_collision.x = (@player_shadow.x + @player_shadow.width/2 - @player_collision.width/2) - 2
            @player.x = @player_collision.x - 21
        end
        @player.y = @player_collision.y - 4
        
        if @jumping    
            if @player_attack_timer <= 20
                @player.play animation: :jump_kick, flip: :"#{@flipped}"
                @player_hitbox.add
                if @flipped == nil
                    @player_hitbox.x = @player.x + @player.width - 6
                else
                    @player_hitbox.x = @player.x - 2
                end
                @player_hitbox.y = @player.y + 43
            else
                @attacking = false
                @player_hitbox.remove
                @player_hitbox.x = -999
                @player_hitbox.y = -999
            end
        else
            if @player_attack_timer <= 5
                @player.play animation: :punch1, flip: :"#{@flipped}"
            elsif @player_attack_timer <= 10
                @player.play animation: :punch3, flip: :"#{@flipped}"
                @player_hitbox.add
                if @flipped == nil
                    @player_hitbox.x = @player.x + @player.width - 10
                else
                    @player_hitbox.x = @player.x + 2
                end
                @player_hitbox.y = @player.y + 9
            elsif @player_attack_timer <= 15
                @player.play animation: :punch4, flip: :"#{@flipped}"
            elsif @player_attack_timer <= 20
                @player.play animation: :punch5, flip: :"#{@flipped}"
            elsif @player_attack_timer <= 29
                @player.play animation: :punch6, flip: :"#{@flipped}"
            else
                @attacking = false
                @player_hitbox.remove
                @player_hitbox.x = -999
                @player_hitbox.y = -999
            end
        end
        @player_attack_timer += 1

    elsif @jumping
        if @player_jump_velocity > 1
            @player.play animation: :jump1, flip: :"#{@flipped}"
        elsif @player_jump_velocity.abs <= 1 
            @player.play animation: :jump2, flip: :"#{@flipped}"
        elsif @player_jump_velocity < -1 
            @player.play animation: :jump3, flip: :"#{@flipped}"
        end

        @player_collision.x = (@player_shadow.x + @player_shadow.width/2 - @player_collision.width/2)

        @player_collision.width = 12
        @player_collision.height = 50
        @player.x = @player_collision.x - 14
        @player.y = @player_collision.y - 1
    elsif @walking
        if @player_walk_timer <= 7
            @player.play animation: :walk1, flip: :"#{@flipped}"
        elsif @player_walk_timer <= 14
            @player.play animation: :walk2, flip: :"#{@flipped}"
        elsif @player_walk_timer <= 21
            @player.play animation: :walk3, flip: :"#{@flipped}"
        elsif @player_walk_timer <= 28
            @player.play animation: :walk4, flip: :"#{@flipped}"
        elsif @player_walk_timer <= 35
            @player.play animation: :walk5, flip: :"#{@flipped}"
        else
            @player_walk_timer = 0
        end
        @player_walk_timer += 1

        @player_collision.x = (@player_shadow.x + @player_shadow.width/2 - @player_collision.width/2)

        @player_collision.width = 12
        @player_collision.height = 50
        @player.y = @player_collision.y - 4

        if @flipped == nil    
            @player.x = @player_collision.x - 10
        else
            @player.x = @player_collision.x - 20
        end

    else
        if @player_idle_timer <= 10
            @player.play animation: :idle1, flip: :"#{@flipped}"
        elsif @player_idle_timer <= 20
            @player.play animation: :idle2, flip: :"#{@flipped}"
        elsif @player_idle_timer <= 30
            @player.play animation: :idle3, flip: :"#{@flipped}"
        elsif @player_idle_timer <= 40
            @player.play animation: :idle2, flip: :"#{@flipped}"
        end
        if @player_idle_timer == 40
            @player_idle_timer = 0
        end
        @player_idle_timer +=1

        @player_collision.x = (@player_shadow.x + @player_shadow.width/2 - @player_collision.width/2)
        @player_collision.width = 13
        @player_collision.height = 50
        @player.y = @player_collision.y - 4
        
        if @flipped == nil    
            @player.x = @player_collision.x - 15
        else
            @player.x = @player_collision.x - 14 
        end

    end

    
    if @i_frames > 0
        @i_frames -= 1
        if @i_frames%1 == 0
            if @i_frames%2 == 0
                @player.add
            else
                @player.remove
            end
        end
    end

    # Collision och sånt i slutet
    if @player_lost != true
        if @enemy_shadow.y > @player_shadow.y
            @enemy_shadow.z = @player_shadow.z + 1 
        else
            @enemy_shadow.z = @player_shadow.z - 1 #Kanske ändra här senare? Ha spelaren som grund z index och låt allt annat anpassa sig till det.
        end
    end
    if @i_frames%2 == 0
        @enemy.z = @enemy_shadow.z
        @player.z = @player_shadow.z
    end

    i = 0
    while i < @fireball_array.length
        if @fireball_array[i][0].x > Window.width + 30 || @fireball_array[i][0].x < -30
            @fireball_array[i][0].remove
            @fireball_array[i][1].remove
            @fireball_array.delete_at(i)
        end
        if i < @fireball_array.length
            @fireball_array[i][1].play flip: :"#{@fireball_array[i][2]}"
            @fireball_array[i][0].x += @fireball_array[i][3]
            @fireball_array[i][1].x = @fireball_array[i][0].x
            @fireball_array[i][1].y = @fireball_array[i][0].y - 4 - @fireball_array[i][4]
            #@fireball_array[i][4] = 10 +  5 * Math.sin(0.05*@float_timer)
            # @float_timer += 1
            fireball_gravity_array = gravity(@fireball_array[i][5], @fireball_array[i][4], 0)
            @fireball_array[i][4] = fireball_gravity_array[0]
            @fireball_array[i][6] = fireball_gravity_array[1]
            if @fireball_array[i][4] > 60
                @fireball_array[i][0].play animation: :smallest
            elsif @fireball_array[i][4] > 45
                @fireball_array[i][0].play animation: :small
            elsif @fireball_array[i][4] > 20
                @fireball_array[i][0].play animation: :big
            else
                @fireball_array[i][0].play animation: :biggest
            end
            if @fireball_array[i][0].y > @player_shadow.y
                @fireball_array[i][0].z = @player_shadow.z + 1
                @player_shadow.z = @fireball_array[i][0].z - 1
            else
                @player_shadow.z = @fireball_array[i][0].z + 1
                @fireball_array[i][0].z =  @player_shadow.z - 1
            end
            @fireball_array[i][1].z = @fireball_array[i][0].z

            if collision( @fireball_array[i][1],  @fireball_array[i][4],  @fireball_array[i][0], @player_collision, @player_dfg, @player_shadow) == "left" && @damaged == false && @i_frames == 0
                @damaged = true
                @flipped = nil
                @fireball_array[i][0].remove
                @fireball_array[i][1].remove
                @fireball_array.delete_at(i)
            elsif collision( @fireball_array[i][1],  @fireball_array[i][4],  @fireball_array[i][0], @player_collision, @player_dfg, @player_shadow) == "right" && @damaged == false && @i_frames == 0
                @damaged = true
                @flipped = "horizontal"
                @fireball_array[i][0].remove
                @fireball_array[i][1].remove
                @fireball_array.delete_at(i)
            elsif @fireball_array[i][4] == 0
                @fireball_array[i][0].remove
                @fireball_array[i][1].remove
                @fireball_array.delete_at(i)
            else
                i += 1
            end
        end
       
    end

    if collision(@enemy_collision, @enemy_dfg, @enemy_shadow, @player_collision, @player_dfg, @player_shadow) == "left" && @i_frames == 0
        @flipped = nil
        @damaged = true
    elsif collision(@enemy_collision, @enemy_dfg, @enemy_shadow, @player_collision, @player_dfg, @player_shadow) == "right" && @i_frames == 0
        @flipped = "horizontal"
        @damaged = true
    end

    if collision(@player_hitbox, @player_dfg, @player_shadow, @enemy_collision, @enemy_dfg, @enemy_shadow) != false && @enemy_damaged == false
        if @flipped == nil
            @enemy_flipped = nil
        else    
            @enemy_flipped = "horizontal"
        end
        @enemy_damaged = true
    end


    if @player_shadow.x < 0
        @player_shadow.x = 0
    end
    if @player_shadow.x > Window.width - @player_shadow.width
        @player_shadow.x = Window.width - @player_shadow.width
    end
    if @player_shadow.y < 77
        @player_shadow.y = 77
    end
    if @player_shadow.y > Window.height - 14
        @player_shadow.y = Window.height - 14
    end


    @background_light.height = 240 + 20*Math.sin(0.01*@background_timer)
    @background_timer += 1

    # debug menu --------------------------------------------
    # fps = (get :fps).to_i
    # text.remove
    # text = Text.new(
    #     "#{@player_dfg.to_i} #{@enemy_dfg.to_i} #{fps} #{player_speed} #{@dash_incrementor} #{collision(@player_hitbox, @player_dfg, @player_shadow, @enemy_collision, @enemy_dfg, @enemy_shadow)}",
    #     x: 20, y: 20,
    #     style: 'bold',
    #     size: 20,
    #     color: 'blue',
    # )
end

show


#IDÉER
#Bossen = mattebok kanske?
#(check) lägga till så att man kan stoppa in gravity och hastighets vektorer i gravity så att den blir mer generell -> kan användas till flygande projektiler som inte påverkas av gravitation.
#Double tap för dash
#arena = rooftop? --> hjälper med perspektivet + lätt att animera
#punch punch kick
#Bossen är en mage --> minimal animations och oändligt attack patterns


#utkast
#Lägga till så att man måste trycka in en direction innan man kan dasha. Behåller direction när man släpper? Up/down flipped mechanic?
#Göra om till help_function
    