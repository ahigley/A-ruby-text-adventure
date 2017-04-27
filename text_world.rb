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
		number = rand(3)
		case number
		when 1
			@loot1 = Items.new
			@items = [@loot1]	
		when 2
			@loot1 = Items.new
			@loot2 = Items.new
			@items = [@loot1, @loot2]
		when 3
			@loot1 = Items.new
			@loot2 = Items.new
			@loot3 = Items.new
			@items = [@loot1, @loot2, @loot3]
		else
			@loot1 = Items.new
			@loot1.desc = "There are no items here."
			@items = [@loot1]
		end
	end


end
