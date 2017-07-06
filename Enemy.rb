#Interaction between enemy class objects and hero class to come -- probably within the Game class.
class Enemy < World
  include Fight
  attr_accessor :hp, :dmg, :xpreward, :loot, :desc

  BASEMOBHP = 1

  def initialize
    @hp = BASEMOBHP
    @dmg = 1
    @xpreward = 10
    @loot = []
    @desc = gen_desc
  end
  def gen_desc
    number = rand(1..3)
    case number
      when 1
        @desc = 'The first type of monster'
      when 2
        @desc = 'The second type of monster'
      when 3
        @desc = 'The third type of monster'
    end
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


end