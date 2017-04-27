ALL_ITEMS = ["Health_pot", "Poison_pot", "Str_pot", "Blank_scroll", "Smiley_scroll"]





class Scroll
	ALL_SCROLLS = ["Blank sheet", "Smiley Sheet"]
	attr_accessor :desc, :type, :symbol
	@@symbols = ["!", "@", "#", "$", "%"]
	def initialize
		@symbol = @@symbols.sample
		@@symbols.delete_at(@@symbols.index(@symbol))
		@desc = "A sheet with a #{@symbol} written on it."
		@type = ALL_SCROLLS.sample
	end
end

class Smiley_scroll
	def effect(target)
		puts "It's just a sheet of paper with a smiley face on it."
	end
end

class Blank_sheet
	def effect(target)
		puts "It seemed to have no effect!"	
	end
end
class Potion
	ALL_POTIONS = ["Healing Potion", "Potion of Strength", "Poison"]
	@@colors = ["green", "red", "pink", "blue", "yellow", "orange", "purple"]
	attr_accessor :desc, :type, :color, :buff, :debuff
	def initialize
		@color = @@colors.sample
		@@colors.delete_at(@@colors.index(@color))
		@desc = "A bottle containing a shimmering #{@color} liquid"
		@type = ALL_POTIONS.sample
	end
end
class Poison_pot < Potion
	def initialize
		super
		@buff = false
		@debuff = true
	end
	def effect(target)
		target.hp -= 3
	end
end

class Health_pot < Potion	
	def initialize
		super
		@buff = true
		@debuff = false
		
	end
	def effect(target)
		target.hp += 3
	end
end
		
class Str_pot < Potion
	def initialize
		@buff = true
		@debuff = false
	end	
	def effect(target)
		target.str += 1
	end
end
test = Health_pot.new
p test.desc
