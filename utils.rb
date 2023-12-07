# From https://github.com/alex-Symbroson/Advent-of-Code/blob/master/2023/helper.rb
class Range
  def intersect?(other)
      !(max < other.begin || other.max < self.begin)
  end

  def intersection(other)
      return nil unless intersect?(other)

      [self.begin, other.begin].max..[max, other.max].min
  end

  def empty?
      size.zero?
  end

  def split(other)
      return nil unless s = self & other

      [self.begin...s.begin, max...s.max].filter { |v| !v.empty? }
  end

  def +(other)
      self.begin + other..max + other
  end
  alias & intersection
end