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
