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
		looking
		game_start
	end

	#Parses user input into words, then disambiguates commands in the word_disambig method, generally starting from @word1
	def choice(input)
		words = input.to_s.split(" ")

		@word1 = words[0]
		@word2 = words[1]
		@word3 = words[2]
		@word4 = words[3]
		@word5 = words[4]


		word_disambig(@word1, @word2, @word3, @word4, @word5)
	end
					
	#Since the Game class is essentially the game engine, most user actions are still here but there is a lot of room for rebuilding. Below you can see we're calling a method within $hero.
	#It's probably going to have a separate class full of user actions alone at some point but for now, it is what it is.



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
		current = $hero.level
		$hero.level?
		if current < $hero.level
			puts "Level up!"
		end
		if $hero.location.monsters.size != 0 && $hero.location.time > 0
			$hero.location.monsters.each do |mob|
				puts "#{mob.desc} attacks you!"
				mob.attack($hero, mob.str)
			end
		end
		$hero.location.time += 1
		number = $hero.location.counter
		if number >= 10
			puts 'You survived ten rooms -- you win!'
			exit
		end
	end
	#Word disambiguation begins by evaluating word1. In some cases that's all that's needed. If word2 is consided relevant word2 is evaluated as well. Right now, for commands like "look" word2 could be anything so 
	#look around is functionally the same as look. The various cmd arrays contain all valid synonymns for a given command. This way new synonymns can be added with  minimal effort. Currently word2 evaluations happen within
	#the elsif structure of evaluating word1 -- it may be worth reworking this in future. Word1_disambig -> word2_disambig. However, this hasn't been done now as generally evaluations of word2 branch off based on word1. That is 
	#to say dump pot has a word2 value of pot but we can only evaluate it within the context of drop_cmds. At present its more orderly to have everything in one place. In future calling seperate methods such as drop_cmds_disambig
	#might be a way of branching with maintaining readability.
	def word_disambig(word1, word2, word3, word4, word5)
			go_cmds = ["go",  "walk", "run", "move", "travel", "skip", "g", "m"]
			fast_move_cmds = ["n", "s", "e", "w"]
			look_cmds = ["look", "see", "l"]
			get_cmds = ["grab", "get", "take"]
			drop_cmds = ["drop", "leave", "dump"]
			status_cmds = ["status", "s", "health", "hp", "xp", "check", "level"]
			inv_cmds = ["inv", "i", "inventory", "loot", "stuff", "gear"]
			quit_cmds = ["q", "quit", "exit", "end"]
			use_cmds = ["use"]
			attack_cmds = ["attack", "hit"]
			@all_cmds << go_cmds
			@all_cmds << (look_cmds + get_cmds + drop_cmds)
			if go_cmds.include?(word1)
				if $hero.location.monsters.size != 0
					puts 'Your enemies are blocking the exit'
				else
					move_disambig(word2)
					looking
				end
			elsif word1 == 'help'
				puts 'some commands:
							go [direction]
							get [thing]
							get [type] [thing] Example: get ! scroll
							use [type] [thing] Example: use orange bottle
							inv - display inventory
							attack [type]
							drop [thing]
							look - gives information about the room/what you can see
							status - displays information about your hp etc.
							q - quits the game'
				# Some developer commands commented out in case they are needed again later
			#elsif word1 == "ah"
			#	$hero.heal(30)
			#elsif word1 == "gen"
			#	$hero.location.item_gen
			#elsif word1 == "boom"
			#	def boom
			#	$hero.location.monsters.each do |mob|
			#		mob.wound(10)
			#		dead = mob.defeated?
			#		if dead == true
			#			$hero.location.monsters.delete_at($hero.location.monsters.index(mob))
			#		end
			#	end
			#	end
			#	boom
			#	boom
			#	boom
			#elsif word1 == 'god'
			#	$hero.hp = 100
			elsif fast_move_cmds.include?(word1)
				move_disambig(word1)
				looking
			elsif look_cmds.include?(word1)
				looking
			elsif get_cmds.include?(word1)
				getting
			elsif drop_cmds.include?(word1)
				dropping
			elsif status_cmds.include?(word1)
				$hero.status_check
			elsif inv_cmds.include?(word1)
				$hero.inv_check
			elsif quit_cmds.include?(word1)
				puts "Thanks for playing!"
				exit
			elsif use_cmds.include?(word1)
						using
			elsif attack_cmds.include?(word1)
				attacking
			else
				puts "I do not recognize that command. Please try again."

			end
	end

def getting
	if @word2 != nil
		if $hero.location.items.size !=0
			gotten = false
			$hero.location.items.each do |item|
				if item.perm_id == @word2 && item.get_words.include?(@word3)
					$hero.inv << item
					$hero.location.items.delete_at($hero.location.items.index(item))
					gotten = true
					break
				end
				if item.get_words.include?(@word2)
					$hero.inv << item
					$hero.location.items.delete_at($hero.location.items.index(item))
					gotten = true
					break
				end
			end
			if gotten == false
				puts "There is no #{@word2} to get!"
			end
		else
			puts "There is no #{@word2} to get!"
		end

	else
		puts "What do you want to get?"
	end
end

	def using
		if !$hero.inv.empty?
			$hero.inv.each do |item|
				if item.get_words.include?(@word3)
					if item.perm_id == @word2
						if @word4 == nil
						$hero.use(item, nil)
						else
						$hero.location.monsters.each do |mob|
							if @word4 = mob.id
								$hero.use(item, mob)
							end
						end
						end
						$hero.inv.delete_at($hero.inv.index(item))
						break
					end
				else
					puts 'You must get an item before you can use it.'
				end
			end
		else
			puts 'You must get an item before you can use it.'
		end
	end

	def dropping
		if @word2 != nil

			if $hero.inv.size != 0
				$hero.inv.each do |item|
					if item.get_words.include?(@word2)
						$hero.location.items << item
						$hero.inv.delete_at($hero.inv.index(item))
						break
					else
						puts "You have no #{@word2} to drop"
						break
					end
				end
			else
				puts "You have no #{@word2} to drop!"

			end
		end
	end

	def looking
		puts "
				 "
		puts $hero.location.desc
		puts "
				 "
		puts "Exits can be found in the following directions:"
		exits = $hero.location.exits.keys
		puts exits.join(" ")
		puts "

				 "
		if $hero.location.monsters.size != 0
			puts "The following enemies are here:"
			$hero.location.monsters.each do |mob|
				puts "#{mob.desc}"
			end
		end
		puts "The following items are on the floor:"
		puts "-" * 30

		items = $hero.location.items
		items.each do |item|
			puts item.desc
		end
		puts "-" * 30

	end
def attacking
	$hero.location.monsters.each do |mob|
		if @word2 == mob.id
			puts "You attack #{mob.desc.downcase}"
			$hero.attack(mob, $hero.str)
			dead = mob.defeated?
			if dead == true
				$hero.location.monsters.delete_at($hero.location.monsters.index(mob))
			end
			break
			break
		else
			puts "There is no #{@word2} to attack"
		end
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
