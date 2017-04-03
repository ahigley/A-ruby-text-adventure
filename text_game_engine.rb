class Game 
	# :ow, :up, and :ah are strictly development commands to ensure values are changing properly, death message
	#
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
		def get(thing)
			$hero.pick_up(thing)
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
			go_cmds = ["go", "walk", "run", "move", "travel", "skip", "g", "m"]
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
					loot = Array.new
					items.each do |item|
						loot << item.desc
					end	
					puts loot.join(" ")
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
					if @word3 != nil
						$hero.inv(@word2).effect(@word3)	
						$hero.inv.delete(@word2)	
					else 
						puts "What do you want to use the #{@word2} on?"
					end
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
