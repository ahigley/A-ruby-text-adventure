module Fight

  def heal(amount)
    @hp += amount
    @hp = [@hp,@max].min
  end

  def wound(amount)
    @hp -= amount
  end

  def attack(target, str)
    to_hit = rand(0..8)
    if to_hit <= (str + 5)
      target.wound(str)
      puts "#{target.desc} is hit for #{str} damage"
    else
      puts "#{target.desc} evades the attack"
    end
  end

end