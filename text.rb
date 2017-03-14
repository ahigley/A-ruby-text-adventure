class Game
	# :ow, :up, and :ah are strictly development commands to ensure values are changing properly, death message
	# triggers when @hero.dead? etc.
	ACTIONS = [
		:ow, :status, :up, :q, :look, :use, :ah, :get, :inventory
		]
	def initialize
		game_start
	end


	# Right now Game initialize triggers Items.new -- this will change when rooms are added. Entering a new room should trigger item 
	# generation. 
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
				if @north_cmds.include?(direction)
					move("north")
				elsif @east_cmds.include?(direction)
					move("east")
				elsif @west_cmds.include?(direction)
					move("west")
				elsif @south_cmds.include?(direction)
					move("south")
				end
		end
		def move(direction)
			if $hero.location.exits.has_key?(direction)
				newroom = $hero.location.exits[direction]
				$hero.location = newroom
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

class Hero
	attr_accessor :level, :hp, :score, :xp, :buff
	attr_accessor :inv, :location

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
		@inv.pop thing
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

class Items
	# Due to problems w/ :pot I've removed :text and :scroll. Remember to add these back in after :pot starts working.
	MASTERLIST = [
		:pot, :text, :scroll
		]

	
	attr_accessor :type

	# Without having @hero = Hero.new in the Items initialize use (:pot) returns an error that 'heal' is not a valid method.
	# Identifying the object with the properties of the Hero class is necessary to call @hero.heal it would seem
	# Game class also initializes @hero = Hero.nex -- does initializing like this again in Items mean that we are 
	# overwriting @hero to the initial state of Hero?
	def initialize
		@type = MASTERLIST.sample
	end

	# @hero.heal is not increasing @hp,even though @hero.heal DOES increase @hp when the :ah command is entered and read within
	# the Game class. A secondary issue is that the potion i sn't destroyed up on use.
	# A second hash other than TYPE is likely needed as TYPE is the master list of all potential items;
	# removing :pot from TYPE would mean that any future rooms (to be added) are unable to generate :pot
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

class Rooms
	attr_accessor :desc, :exits, :items, :name, :starting, :room_num

	@@room_count = 0
	def initialize
		@starting = false
		@room_num = @@room_count
		@@room_count += 1
		@exits = Hash.new
		@items = Array.new
	end
		

	
		
	def desc_gen
		choice = rand(3)
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

	def exits_gen
		number = rand(4)
		possible = ["north", "south", "east", "west"]
		if @exits.include?("north")
			possible.delete("north")
		elsif @exits.include?("south")
			possible.delete("south")
		elsif @exits.include?("east")
			possible.delete("east")
		elsif @exits.include?("west")
			possible.delete("west")	
		end
		number.times do
				element = rand((possible.length + 1))
				@exits.push(possible[element])
				possible.delete_at(element)
			end
	end



end

@room1 = Rooms.new
@room1.item_gen
@room1.desc = "Welcome to room one."
@room2 = Rooms.new
@room2.item_gen
@room2.desc = "Welcome to room two."
@room3 = Rooms.new
@room3.item_gen
@room3.desc = "Welcome to room three."
$start_room = Rooms.new
$start_room.desc = "Welcome to the starting room."
$start_room.exits = { "north" => @room1,
		      "west" => @room2,
		      "east" =>  @room3
}
@room3.exits = {"west" => $start_room}
@room2.exits = {"east" => $start_room}
@room1.exits = {"south" => $start_room}

$hero = Hero.new
Game.new

