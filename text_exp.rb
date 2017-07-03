puts "This game is under development. If you're confused about something e-mail me at addison.higley@gmail.com"
# An attempt at making the files a bit more manageable
require_relative 'game_engine.rb'
require_relative 'text_world.rb'
require_relative 'fight.rb'
require_relative 'text_hero.rb'
require_relative 'text_items.rb'	


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
		puts 'You have defeated the enemy'
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

