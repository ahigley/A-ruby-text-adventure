class Items
	MASTERLIST = [
		:potion, :scroll
		]

	
	attr_accessor :master_type, :desc, :type, :effect, :buff, :debuff

	def initialize
		@master_type = MASTERLIST.sample
		case @master_type
		when :potion
			potion = Potions.new
			@type = potion.type
			@desc = potion.desc
			@effect = potion.effect
			@buff = potion.buff
			@debuff = potion.debuff
		
		when :scroll
			@subtype = Scrolls.new
		end
	end

	def use
		case @master_type
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




end

class Scrolls < Items
	ALL_SCROLLS = ["Blank sheet", "Smiley Sheet"]
	def initialize
	end
end
class Potions < Items
	ALL_POTIONS = ["Healing Potion", "Potion of Strength", "Poison"]
	@@colors = ["green", "red", "pink", "blue", "yellow", "orange", "purple"]
	attr_accessor :desc, :type, :buff, :debuff, :colors 
	def initialize
		@colors = Array.new
		@colors << @@colors.sample
		@colors = (@@colors - @colors)
		
		@desc = "A bottle containing a shimmering #{@color.to_s} liquid"
		@type = ALL_POTIONS.sample
		case @type
		when@type == "Healing Potion"
			pot = Health_pot.new
			@type = pot
			@buff = pot.buff
			@debuff = pot.debuff
			effect(target) == pot.effect(target)
		when @type == "Potion of Strength"
			Str_pot.new
		when @type == "Poison"
			pot = Poison_pot.new
			@type = pot
			@buff = pot.buff
			@debuff = pot.debuff
			effect(target) == pot.effect(target)	
		end
	end
end
class Poison_pot < Potions
	def initialize
		@buff = false
		@debuff = true
	end
	def effect(target)
		target.hp -= 3
	end
end

class Health_pot < Potions	
	def initialize
		@buff = true
		@debuff = false
		
	end
	def effect(target)
		target.hp += 3
	end
end
		
class Str_pot < Potions
	def initialize
		@buff = true
		@debuff = false
	end	
	def effect(target)
		target.str += 1
	end
end