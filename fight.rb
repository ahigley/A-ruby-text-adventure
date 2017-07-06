module Fight

  def heal(amount)
    @hp += amount
    @hp = [@hp,@max].min
  end

  def wound(amount)
    @hp -= amount
  end

  def attack(target)
    target.wound(1)
  end

end