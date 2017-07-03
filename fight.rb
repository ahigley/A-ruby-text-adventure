module Fight

  def heal(amount)
    @hp += amount
    @hp = [@hp,@max].min
  end
end