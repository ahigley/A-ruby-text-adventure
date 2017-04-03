puts "This game is still under development. For questions or help contact me at addison.higley@gmail.com"
puts "If you are here because I applied for an internship, please hire me. This game is basic but I'm learning quickly."
puts "I would rather be building something worth some money than this."

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


	
		
		
		
class Game 
	# :ow, :up, and :ah are strictly development commands to ensure values are changing properly, death message
	# triggers when @hero.dead? etc.
	ACTIONS = [
		:ow, :status, :up, :q, :look, :use, :ah, :get, :inventory
		]
	#exits_possible will be a counter which counts the number of nil exits. nil exits represent unexplored exits so if the number of nil exits ever equals 1 then that means there are no other openings.
	#I'd like to change the algorithm so that there is always a path to continue onwards. Getting boxed out of further exploration sounds really lame, but it is possible in the current build.
	attr_writer :all_cmds, :all_rooms, :exits_possible
	def initialize
		@@all_rooms ={"0, 0" => $start_room, "0, 1" => nil, "-1, 0" => nil, "1, 0" => nil }
		@all_cmds = Array.new
		game_start
	end

	#Parses user input into words, then disambiguates commands in the word_disamibig method, generally starting from @word1
	def choice(input)
		words = input.to_s.split(" ")

		@word1 = words[0]
		@word2 = words[1]
		@word3 = words[2]

		@north_cmds = ["n", "up", "north"]
		@east_cmds = ["e", "right", "east"]
		@west_cmds = ["w", "left", "west"]
		@south_cmds = ["s", "down", "south"]
		@all_cmds << (@north_cmds + @east_cmds + @west_cmds + @south_cmds)
		word_disambig(@word1, @word2, @word3)
	end
		def move_check(word)
			allowed = @north_cmds + @east_cmds + @west_cmds + @south_cmds

			if allowed.include?(word)
				move_disambig(word)
			else
				puts "You cannot go #{word}"
			end
		end
					
	#Since the Game class is essentially the game engine, most user actions are still here but there is a lot of room for rebuilding. Below you can see we're calling a method within $hero.
	#It's probably going to have a separate class full of user actions alone at some point but for now, it is what it is.
		def get(thing)def move_disambig(direction)
			@north_cmds = ["n", "up", "north"]
			@east_cmds = ["e", "right", "east"]
			@west_cmds = ["w", "left", "west"]
			@south_cmds = ["s", "down", "south"]

					xy = $hero.location.xy.split(", ")
					x = xy[0].to_i
					y = xy[1].to_i
				if @north_cmds.include?(direction)
					if $hero.location.exits.include?("north")
						check_room("north", x, (y + 1))
						move("north")
					else
						puts "There is no exit to the north!"
					end
				elsif @east_cmds.include?(direction)
					if $hero.location.exits.include?("east")
						check_room("east", (x + 1), y)
						move("east")
					else
						puts "There is no exit to the east!"
					end
				elsif @west_cmds.include?(direction)
					if $hero.location.exits.include?("west")
						check_room("west", (x - 1), y)
						move("west")
					else
						puts "There is no exit to the west!"
					end
				elsif @south_cmds.include?(direction)
					if $hero.location.exits.include?("south")
						check_room("south", x, (y - 1))
						move("south")
					else 
						puts "There is no exit to the south!"
					end
				end
		end
		def move(direction)
				newroom = $hero.location.exits[direction]
				puts "move"
				p newroom
				$hero.location = newroom
				$hero.location.xy = newroom.xy
		end

	def check_room(direction, x, y)
			xy_pos = "#{x}, #{y}"	
		if @@all_rooms.has_key?(xy_pos) && (@@all_rooms[xy_pos] != nil)
			check_exits(x, y)
		else
			generate(direction, x, y)
		end
	end


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

			$hero.pick_up(thing)
		end

		#This is really the start of the algorithm responsible for generating new rooms. If rooms weren't drawn as you attempt to enter them, the algorithm could be kept separate from the move method. I like this way better
		#because it means that later, if we count the number of unexplored exits, we could then change the algorithm to force additional open doors -- that way you're guarenteed to always have new exits available. 
		def move_disambig(direction)
			@north_cmds = ["n", "up", "north"]
			@east_cmds = ["e", "right", "east"]
			@west_cmds = ["w", "left", "west"]
			@south_cmds = ["s", "down", "south"]

					xy = $hero.location.xy.split(", ")
					x = xy[0].to_i
					y = xy[1].to_i
				if @north_cmds.include?(direction)
					if $hero.location.exits.include?("north")
						check_room("north", x, (y + 1))
						move("north")
					else
						puts "There is no exit to the north!"
					end
				elsif @east_cmds.include?(direction)
					if $hero.location.exits.include?("east")
						check_room("east", (x + 1), y)
						move("east")
					else
						puts "There is no exit to the east!"
					end
				elsif @west_cmds.include?(direction)
					if $hero.location.exits.include?("west")
						check_room("west", (x - 1), y)
						move("west")
					else
						puts "There is no exit to the west!"
					end
				elsif @south_cmds.include?(direction)
					if $hero.location.exits.include?("south")
						check_room("south", x, (y - 1))
						move("south")
					else 
						puts "There is no exit to the south!"
					end
				end
		end
		def move(direction)
				newroom = $hero.location.exits[direction]
				puts "move"
				p newroom
				$hero.location = newroom
				$hero.location.xy = newroom.xy
		end

	def check_room(direction, x, y)
			xy_pos = "#{x}, #{y}"	
		if @@all_rooms.has_key?(xy_pos) && (@@all_rooms[xy_pos] != nil)
			check_exits(x, y)
		else
			generate(direction, x, y)
		end
	end


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
	#This is effectively the end of the procedural generation algorithm. 
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
		end
		if $hero.location.exits.has_key?(direction)
			newroom = $hero.location.exits[direction]
			$hero.location = newroom
			$hero.xy = newroom.xy
		else
			puts "You cannot travel #{direction}. The path does not lead there."
		end
	end
	def resolve
		$hero.level?
	end
	#Word disambiguation begins by evaluating word1. In some cases that's all that's needed. If word2 is considered relevant word2 is evaluated as well. Right now, for commands like "look" word2 could be anything so 
	#look around is functionally the same as look. The various cmd arrays contain all valid synonymns for a given command. This way new synonymns can be added with  minimal effort. Currently word2 evaluations happen within
	#the elsif structure of evaluating word1 -- it may be worth reworking this in future. Word1_disambig -> word2_disambig. However, this hasn't been done now as generally evaluations of word2 branch off based on word1. That is 
	#to say dump pot has a word2 value of pot but we can only evaluate it within the context of drop_cmds. At present its more orderly to have everything in one place. In future calling seperate methods such as drop_cmds_disambig
	#might be a way of branching with maintaining readability.
	def word_disambig(word1, word2, word3) 
			go_cmds = ["go",  "walk", "run", "move", "travel", "skip", "g", "m"]
			fast_move_cmds = ["n", "s", "e", "w"]
			look_cmds = ["look", "see", "l"]
			get_cmds = ["grab", "get", "take"]
			drop_cmds = ["drop", "leave", "dump"]
			status_cmds = ["status", "s", "health", "hp", "xp", "check", "level"]
			inv_cmds = ["inv", "i", "inventory", "loot", "stuff", "gear"]
			quit_cmds = ["q", "quit", "exit", "end"]
			use_cmds = ["use"]
			@all_cmds << go_cmds
			@all_cmds << (look_cmds + get_cmds + drop_cmds)
			if go_cmds.include?(word1)
				move_disambig(word2)
			elsif fast_move_cmds.include?(word1)
				move_disambig(word1)
			elsif look_cmds.include?(word1)
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
			elsif get_cmds.include?(word1)
				if @word2 != nil
					if $hero.location.items.include?(@word2)
						$hero.inv << @word2
						$hero.location.items.delete_at($hero.location.items.index(@word2))
					else
						puts "There is no #{@word2} to get!"
					end
				else
					puts "What do you want to get?"
				end
			elsif drop_cmds.include?(word1)
				if $hero.location.items.include?(@word2)
					$hero.location.items << thing
					$hero.inv.delete_at($hero.inv.index(@word2))
				elsif
					puts "You have no #{@word2} to drop!"
				end
			elsif status_cmds.include?(word1)
				$hero.status_check
			elsif inv_cmds.include?(word1)
				$hero.inv_check
			elsif quit_cmds.include?(word1)
				puts "Thanks for playing!"
				exit
			elsif use_cmds.include?(word1)
				if $hero.inv.include?(@word2)
					$hero.use(@word2)	
				else
					puts"You must get an item before you can use it."
				end
			else 
				puts "I do not recognize that command. Please try again."
			end
				

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
#World class is nearly entirely scruft at this point. Orginally it held the procedural generation alrorithm. The decision to draw rooms as they were moved to meant that the algorithm had to be moved
#into the Game class.
class World < Game
	attr_accessor :all_rooms, :exits_possible
	def initialize
		
			end
	
end		
class Rooms < World
	attr_accessor :desc, :exits, :items, :xy
	# @@room_count currently serves no purpose, but its long term purpose to set score/mob difficulty. Additionally if we want a 'stairs down' option after a certain number of rooms like one might find in diablo or pixel dungeon
	# then generating stairs after a certain number of rooms could also be possible. Currently this is not implemented into the procedural generation algorithm.
	@@room_count = 0
	def initialize
		@@room_count += 1
		@exits = Hash.new
		@items = Array.new
		@xy = String.new
	end
		

	
	#Needs to be rewritten to contain an array of description types. Then array.sample could be used to pick a description. Moreover duplicating certain description types would offer a method of 
	#weighting which types of rooms generated -- luxurious treasure rooms should occur less often than barren rooms.	
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
	#Currently item_gen is in no way connected to desc_gen -- this needs to be changed. desc_gen only has place holder generation descrsiptions at the moment. In future meaninful descriptions should pair with some sort of loot
	#table. If the description generated is a treasure room, the chance of loot should be higher. Additionally an alchemists chamber should have a higher chance of generating potions. Presently this isn't represented in item_gen
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
	#delete(thing) is within Hero class but use, within the Game class, is really the driving force behind deleting things from the inventory. Drop would be another example. This method will likely be deleted and its functionality
	#moved to the Game class later.
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
	#The next two methods level? and max_up deal with hit points and experience points/level. Right now the Enemy class has been created but interaction between the hero and enemies has not. Level, experience, and health will become
	#relevant once that interaction has been implemented.
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
#Interaction between enemy class objects and hero class to come -- probably within the Game class.
class Enemy < World
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
		$hero.location.loot << @loot		
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

#Some starting conditions to get the program moving. $hero should become @hero at some stage once scope issues have been resolved; though there are no plans to ever allow more than a single hero so maybe it's OK as is.
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

