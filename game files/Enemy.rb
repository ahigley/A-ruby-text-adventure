#Interaction between enemy class objects and hero class to come -- probably within the Game class.
class Enemy < World
  include Fight
  attr_accessor :hp, :dmg, :xpreward, :loot, :desc, :id

  BASEMOBHP = 1

  def initialize
    @hp = BASEMOBHP
    @dmg = 1
    @xpreward = 75
    @loot = []
    gen_desc
  end
  def gen_desc
    number = rand(1..3)
    case number
      when 1
        @desc = 'A scaly kobold'
        @id = 'kobold'
      when 2
        @desc = 'A slimy ball of slime'
        @id = 'slime'
      when 3
        @desc = 'A leathery goblin'
        @id = 'goblin'
    end
  end

  def defeated?
   if
   @hp <= 0
     puts 'You have defeated the enemy'
     $hero.xp(@xpreward)
      $hero.bonus(100)
     return true
   else
     return false
   end

  end

  def alive?
    @hp >0
  end


end