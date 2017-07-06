ALL_ITEMS = %w(Health_pot Poison_pot Str_pot Blank_scroll Smiley_scroll)





class Scroll
	ALL_SCROLLS = ['Blank sheet', 'Smiley Sheet']
	attr_accessor :desc, :type, :symbol, :get_words
	@@symbols = %w(! @ # $ %)
	def initialize
		@symbol = @@symbols.sample
		@@symbols.delete_at(@@symbols.index(@symbol))
		@type = ALL_SCROLLS.sample
		@get_words = %w(paper note scroll sheet)
	end

end

class Smiley_scroll < Scroll
	attr_accessor  :perm_id, :symbol_set
	@@symbol_set = false
	def initialize
		super
		if @@symbol_set = false
		@@perm_id = @symbol
			@@symbol_set = true
		end
		@perm_id = @@perm_id
		@desc = "A sheet with a #{@@perm_id} written on it."

	end



	def effect(target)
		puts "It's just a sheet of paper with a smiley face on it."
	end
end

class Blank_sheet < Scroll
	attr_accessor  :perm_id, :symbol_set
	@@symbol_set = false
	def initialize
		super
		if @@symbol_set == false
			@@perm_id = @symbol
			@@symbol_set = true
		end
		@perm_id = @@perm_id
		@desc = "A sheet with a #{@@perm_id} written on it."

	end

	def effect(target)
		puts 'It seemed to have no effect!'
  end
end
class Potion
	ALL_POTIONS = ['Healing Potion', 'Potion of Strength', 'Poison']
	@@colors = %w(green red pink blue yellow orange purple)
	attr_accessor :desc, :type, :color, :buff, :debuff, :get_words, :color_set, :perm_id
	def initialize
		@color = @@colors.sample
		@@colors.delete_at(@@colors.index(@color))
		#@desc = "A bottle containing a shimmering #{@color} liquid"
		@type = ALL_POTIONS.sample
		@get_words = %w(pot potion bottle)
	end
end


class Poison_pot < Potion

@@color_set = false
	def initialize
	        super
					if @@color_set == false
						@@perm_id = @color
						@@color_set = true
					end
					@perm_id = @@perm_id
					@desc = "A bottle containing a shimmering #{@@perm_id} liquid"
		@buff = false
		@debuff = true
	end
	def effect(target)
		target.hp -= 3
		puts "#{target.desc} has been poisoned"
	end
end

class Health_pot < Potion
	@@color_set = false
	def initialize
		super
		if @@color_set == false
			@@perm_id = @color
			@@color_set = true
		end
		@perm_id = @@perm_id
		@desc = "A bottle containing a shimmering #{@@perm_id} liquid"
		@buff = false
		@debuff = true
	end
	def effect(target)
		target.heal(3)
		puts "#{target.desc} has been healed"
	end
end
		
class Str_pot < Potion
	@@color_set = false
	def initialize
		super
		if @@color_set == false
			@@perm_id = @color
			@@color_set = true
		end
		@perm_id = @@perm_id
		@desc = "A bottle containing a shimmering #{@@perm_id} liquid"
		@buff = false
		@debuff = true
	end
	def effect(target)
		puts "desc"
		puts target.desc
		target.str += 1
		puts "#{target.desc} is now stronger"
	end
end

