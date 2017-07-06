class Hero < World
	include Fight
	attr_accessor :level, :hp, :score, :xp, :buff, :str, :desc
	attr_accessor :inv, :location, :xy

	BASEHP = 10
	
	def initialize
		@desc = "Hero"
		@location = $start_room
		@str = 1
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

	def use(thing, target)
			if target == nil
			thing.effect(self)
			else
				thing.effect(target)
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
			puts"Your inventory contains the following items:\n\n"
			@inv.each { |x| puts"#{x.desc}" }
			puts "\n"
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
