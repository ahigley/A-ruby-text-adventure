
class Enemy
	attr_accessor :hp, :dmg, :xpreward, :loot

	BASEMOBHP = 1

	def initialize
		@hp = BASEMOBHP
		@dmg = 1
		@xpreward = 10
		@loot = []
	end

	def defeated?
		@hp <= 0
		puts "You have defeated the enemy"
		$hero.xp(@xpreward)
		$hero.pick_up(@loot)
	end
	
	def alive?
		@hp >0
	end

	def attack
		$hero.wound(@dmg)
	end

	def wound(amount)
		@hp -= amount
	end
end

class Items
	MASTERLIST = [
		:pot, :text, :scroll
		]

	
	attr_accessor :type

	def initialize
		@type = MASTERLIST.sample
	end

	def use
		case @type
		when :pot
			puts"You chug the contents of the bottle."
			$hero.heal(3)
		when :text
			puts"Looking closely, you can see a simple drawing of a face on the paper:

			=)

			"
		when :scroll
			puts"You read the scroll to produce a magical effect, but nothing happens!"
		end
	end

	def potion
		end



end


class World
	attr_accessor :all_rooms, :exits_possible
	def initialize
		
		@@all_rooms ={"0, 0" => $start_room, "0, 1" => nil, "-1, 0" => nil, "1, 0" => nil }
		@exits_possible = 0
	end


	def check_room(direction, x, y)
			xy_pos = "#{x}, #{y}"	
		if @@all_rooms.has_key?(xy_pos) && (@@all_rooms[xy_pos] != nil)
			check_exits(x, y)
		else
			generate(direction, x, y)
		end
	end

	# These methods check to see if there is a room immediately next to the room that needs exits to be generated. If there is already a room immediately next to the room being generated, the exit to that room is set.
	# TO DO: replace $hero.at with room abstract so these methods can be called for newly generated rooms.
	def check_exits(x, y)
		n = y+1
		s = y-1
		e = x+1
		w = x-1
		north = "#{x}, #{n}"
		south = "#{x}, #{s}"
		east = "#{e}, #{y}"
		west = "#{w}, #{y}"
		room = @@all_rooms["#{x}, #{y}"]
		if @@all_rooms.has_key?(east) && (@@all_rooms[east] != nil)
			room.exits.merge!({"east" => @@all_rooms[east]})
		elsif @@all_rooms.has_key?([west]) && (@@all_rooms[west] != nil)
			room.exits.merge!({"west" => @@all_rooms[west]})
		elsif @@all_rooms.has_key?([north]) && (@@all_rooms[north] != nil)
			room.exits.merge!({"north" => @@all_rooms[north]})
		elsif @@all_rooms.has_key?([south]) && (@@all_rooms[south] != nil)
			room.exits.merge!({"south" => @@all_rooms[south]})
		end
	end

		
	def generate(direction, x, y)
		@room = Rooms.new
		@room.desc_gen
		@room.item_gen
		@room.xy = "#{x}, #{y}"
		new_room = { @room.xy => @room}
		@@all_rooms.merge!(new_room)
		check_exits(x,y)
		if direction == "north"
			new_north = {"south" => $hero.location}
			@room.exits.merge!(new_north)
			north = {"north" => @room}
			$hero.location.exits.merge!(north)
		elsif direction == "south"
			new_south = {"north" => $hero.location}
			@room.exits.merge!(new_south)
			south = {"south" => @room}
			$hero.location.exits.merge!(south)
		elsif direction == "east"
			new_east = {"west" => $hero.location}
			@room.exits.merge!(new_east)
			east = {"east" => @room}
			$hero.location.exits.merge!(east)
		elsif direction == "west"
			new_west = {"east" => $hero.location}
			@room.exits.merge!(new_west)
			west = {"west" => @room}
			$hero.location.exits.merge!(west)
		end
		check_exits(x, y)
		possible = (["north", "south", "east", "west"] - @room.exits.keys)
		(rand(possible.count)).times do |gen|
			actual = (possible - @room.exits.keys)
			gen = actual.sample
			@room.exits.merge!({gen => nil})
		end
	end
end		
		
		
		
		
class Rooms < World
	attr_accessor :desc, :exits, :items, :xy

	@@room_count = 0
	def initialize
		@@room_count += 1
		@exits = Hash.new
		@items = Array.new
		@xy = String.new
	end
		

	
		
	def desc_gen
		choice = rand(1..3)
		case choice
		when 1
			@desc = "You see... the first type of room!"
		when 2
			@desc = "You see... the second type of room!"
		when 3
			@desc = "You see... the third type of room!"
		end
	end

	def item_gen
		number = (1 + rand(3))
		case number
		when 1
			@loot1 = Items.new
			@items = [@loot1.type.to_s]	
		when 2
			@loot1 = Items.new
			@loot2 = Items.new
			@items = [@loot1.type.to_s, @loot2.type.to_s]
		when 3
			@loot1 = Items.new
			@loot2 = Items.new
			@loot3 = Items.new
			@items = [@loot1.type.to_s, @loot2.type.to_s, @loot3.type.to_s]
		else
			@items = ["There are no items here."]
		end
	end




end
class Game < World
	# :ow, :up, and :ah are strictly development commands to ensure values are changing properly, death message
	# triggers when @hero.dead? etc.
	ACTIONS = [
		:ow, :status, :up, :q, :look, :use, :ah, :get, :inventory
		]
	def initialize
		game_start
	end


	def choice(input)
		words = input.to_s.split(" ")

		@word1 = words[0]
		@word2 = words[1]
		@word3 = words[2]

		@north_cmds = ["n", "up", "north"]
		@east_cmds = ["e", "right", "east"]
		@west_cmds = ["w", "left", "west"]
		@south_cmds = ["s", "down", "south"]

		def move_check(word)
			allowed = @north_cmds + @east_cmds + @west_cmds + @south_cmds

			if allowed.include?(word)
				move_disambig(word)
			else
				puts "You cannot go #{word}"
			end
		end
		def move_disambig(direction)
			@north_cmds = ["n", "up", "north"]
			@east_cmds = ["e", "right", "east"]
			@west_cmds = ["w", "left", "west"]
			@south_cmds = ["s", "down", "south"]
					xy = $hero.location.xy.split(", ")
					x = xy[0].to_i
					y = xy[1].to_i
				if @north_cmds.include?(direction)
					check_room("north", x, (y + 1))
					move("north")
				elsif @east_cmds.include?(direction)
					check_room("east", (x + 1), y)
					move("east")
				elsif @west_cmds.include?(direction)
					check_room("west", (x - 1), y)
					move("west")
				elsif @south_cmds.include?(direction)
					check_room("south", x, (y - 1))
					move("south")
				end
		end
		def move(direction)
			if $hero.location.exits.has_key?(direction)
				newroom = $hero.location.exits[direction]
				$hero.location = newroom
				$hero.location.xy = newroom.xy
			else
				puts "You cannot travel #{direction}. The path does not lead there."
			end
		end


		case input
		when "ow"
			$hero.wound(1)
		when "status"
			$hero.status_check
		when "up"
			$hero.xp(100)
		when "ah"
			$hero.heal(1)
		when "inv"
			$hero.inv_check
		when "get"
			puts"What do you want to get?"
		when "get #{@word2}"
			if $hero.location.items.include?(@word2)
				$hero.pick_up(@word2)
				$hero.location.items.delete_at($hero.location.items.index(@word2))
			else
				puts "There is no #{@word2} to get!"
			end
		when "q"
			puts"Thanks for playing."
			exit
		when "look"
			puts "

			"
			p $hero.location.desc.to_s
			puts "

			"
			puts "Exits can be found in the following directions:"
			exits = $hero.location.exits.keys
			puts exits.join(" ")
			puts "

			"
			puts "The following items are on the floor:"
			items = $hero.location.items
			puts items.join(" ")
			
		when "use"
			puts"What do you want to use?"
		when "use #{@word2}"
			if $hero.inv.include?(@word2) == true
				$hero.use(@word2)	
			else
				puts"You must get an item before you can use it."
			end
		when "go"
			puts "Where do you want to go?"
		when "move #{@word2}"
			if direction.include?(@word2)
				move(@word2)
			else
				puts "You cannot go #{@word2}"
			end
		when "go #{@word2}"
			move_check(@word2)	
		when "w"
			move("west")
		when "n"
			move("north")
		when "s"
			move("south")
		when "e"
			move("east")
		else
			puts "I do not recognize that command. Please try again."
		end

	end	

	

	def move(direction)
		north = ["n", "up", "north"]
		east = ["e", "right", "east"]
		west = ["w", "left", "west"]
		south = ["s", "down", "south"]
		if north.include?(direction)
			direction == "north"
		elsif east.include?(direction)
			direction == "east"
		elsif west.include?(direction)
			direction == "west"
		elsif south.include?(direction)
			direction == south
			if $hero.location.exits.has_key?(direction)
				newroom = $hero.location.exits[direction]
				$hero.location = newroom
				$hero.xy = newroom.xy
			else
				puts "You cannot travel #{direction}. The path does not lead there."
			end
		end
	end
	def resolve
		$hero.level?
	end

	def game_start
		while $hero.life? 
			puts "What is your next move, brave hero?"
			@input = gets.chomp.to_s	
			choice(@input)
			resolve

			end
	if $hero.dead?
		puts "You have died."
	end
	end
end

class Hero < World
	attr_accessor :level, :hp, :score, :xp, :buff
	attr_accessor :inv, :location, :xy

	BASEHP = 10
	
	def initialize
		@location = $start_room
		@level = 1
		@max = BASEHP
		@hp = BASEHP
		@score = 0
		@inv = []
		@xp = 0
		@buff = []
	end
	def life?
		@hp > 0
	end

	def dead?
		@hp <= 0
	
	end

	def pick_up(thing)
		@inv << thing
	end

	def drop(thing)
		self.location.items << thing
		@inv.delete_at(index(thing) || puts "You have no #{thing} to drop!")
	end
	def use(thing)
			if @inv.include?(thing)
				case thing
					when "pot"
						puts"You chug the contents of the bottle."
						$hero.heal(3)
						delete(thing)
					when "text"
						puts"Looking closely, you can see a simple drawing of a face on the paper:

						=)

						"
						delete(thing)
					when "scroll"
						puts"You read the scroll to produce a magical effect, but nothing happens!"
						delete(thing)
					end
			else
				puts "You don't have a #{thing} to use."
			end
	end
	def delete(thing)
		@inv.delete_at(@inv.index(thing))
	end
	def inv_check
		if @inv.empty? == true
			puts"You do not have anything in your inventory."
		elsif @inv.empty? !=true
			@inv.each { |x| puts"#{x}" }
		end
	end
	# Xp/level is checked each input cycle - at this time I can't figure out how to increase current xp a single time only 
	# At level 2 max hp increases by 5. This should also result in @hp += 5, but only once.
	# If written into the level? method, @hp increases every input cycle which is not desired.
	# If written into the level? method, @hp increases every input cycle which is not desired.
	def level?
		
		if @xp < 100
			level_up(1)
			
		elsif 300 > @xp && @xp  >= 100
			level_up(2)
			max_up(2) 
			
		elsif 900 > @xp && @xp  >= 300
			level_up(3)
			max_up(3) 

		elsif @xp >= 900
			level_up(4)
			max_up(4) 
		end
	end

	def max_up(amount)
		if amount == 2
			@max = 15
		elsif amount == 3
			@max = 22.5
		elsif amount == 4
			@max = 32.5
		end
	end

	def xp(amount)
		@xp += amount
	end


	def level_up(amount)
		@level = amount
	end

	def heal(amount)
		@hp += amount
		@hp = [@hp,@max].min
	end

	def wound(amount)
		@hp -= amount
	end	

	def bonus(amount)
		@score += amount
	end
	
	def status_check
		print "~"*40
	        print "status"
	        puts "~"*40	
		puts "HP: #{@hp}/#{@max}"
		puts "XP: #{@xp}"
		puts "Level: #{@level}"
		puts "Score: #{@score}"
	end
end

$start_room = Rooms.new
$start_room.desc = "Welcome to the starting room."
$start_room.xy = "0, 0"
$start_room.exits = { "north" => nil,
			"west" => nil,
     			 "east" => nil 
		} 
World.new
$hero = Hero.new
Game.new

