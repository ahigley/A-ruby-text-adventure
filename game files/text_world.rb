#World class is nearly entirely scruft at this point. Orginally it held the procedural generation alrorithm. The decision to draw rooms as they were moved to meant that the algorithm had to be moved
#into the Game class.
class World < Game
	attr_accessor :all_rooms, :exits_possible
	def initialize
		
			end
	
end		
class Rooms < World
	attr_accessor :desc, :exits, :items, :xy, :monsters, :time, :room_count
	# @@room_count currently serves no purpose, but its long term purpose to set score/mob difficulty. Additionally if we want a 'stairs down' option after a certain number of rooms like one might find in diablo or pixel dungeon
	# then generating stairs after a certain number of rooms could also be possible. Currently this is not implemented into the procedural generation algorithm.
	@@room_count = 0
	def initialize
		@time = 0
		@@room_count += 1
		@exits = Hash.new
		@items = Array.new
		@xy = String.new
		@monsters = Array.new
		enemy_gen
	end

	def counter
		return @@room_count
	end
	
	#Needs to be rewritten to contain an array of description types. Then array.sample could be used to pick a description. Moreover duplicating certain description types would offer a method of 
	#weighting which types of rooms generated -- luxurious treasure rooms should occur less often than barren rooms.	
	def desc_gen
		choice = rand(1..3)
		case choice
		when 1
			@desc = 'You are in a meadow full of tall grass'
		when 2
			@desc = 'You are in a dense forest'
		when 3
			@desc = 'You are in a rocky clearing'
		end
	end
	def enemy_gen
		number = rand(4)
		case number
			when 1
				@monsters[0] = Enemy.new
			when 2
				@monsters[0] = Enemy.new
				@monsters[1] = Enemy.new
			when 3
				@monsters[0] = Enemy.new
				@monsters[1] = Enemy.new
				@monsters[2] = Enemy.new
			when 4
				@monsters = []
			else @monsters = []
		end
	end


	#Currently item_gen is in no way connected to desc_gen -- this needs to be changed. desc_gen only has place holder generation descriptions at the moment. In future meaningful descriptions should pair with some sort of loot
	#table. If the description generated is a treasure room, the chance of loot should be higher. Additionally an alchemists chamber should have a higher chance of generating potions. Presently this isn't represented in item_gen
	def item_gen
		number = rand(3)
		case number
		when 1
			item_gen2(1)
		when 2
			item_gen2(2)
		when 3
			item_gen2(3)
		else
			@items = []
		end
	end
	def item_gen2(number)
		number.times do
			type = ALL_ITEMS.sample
		case type
		when 'Health_pot'
			@items.push(Health_pot.new)
		when 'Poison_pot'
			@items.push(Poison_pot.new)
		when 'Str_pot'
			@items.push(Str_pot.new)
		when 'Blank_scroll'
			@items.push(Blank_sheet.new)
		when 'Smiley_scroll'
			@items.push(Smiley_scroll.new)
		end
			end
	end
end
