class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    p array
    return Node.new(array[0]) if array.length == 1
    return nil if array.length < 1
    mid = array.length / 2

    root = Node.new(array[mid])
    root.left = build_tree(array[0..mid -1])
    root.right = build_tree(array[mid + 1..array.length])

    root
  end

  def insert(value, node = root)
    return nil if value == node.value

    if value < node.value
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else 
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = root)
    return nil if node.nil?

    if value < node.value
      node.left = delete(value, node.left)
    elsif value > node.value
      node.right = delete(value, node.right)
    else
      if node.left.nil?
        node = node.right
        return node
      elsif node.right.nil?
        node = node.left
        return node
      else 
        successor = far_left_node(node.right)
        delete(successor.value, node)
        node.value = successor.value
      end
    end
    node
  end

  #private
  def far_left_node(node) 
    node = node.left until node.left.nil?
    return node
  end

  def find(value, node = root)
    return nil if node.nil?
    
    if value < node.value
      node.left = find(value, node.left)
    elsif value > node.value
      node.right = find(value, node.right)
    else
      return node
    end
  end

  def level_order
    queue = Array.new
    visited = Array.new
    queue.push(root)
    c = 0
    until queue.empty? 
      node = queue.shift
      c += 1
      visited.push(block_given? ? yield(node, c) : node.value)
      queue.push(node.left) if node.left
      queue.push(node.right) if node.right
    end

    visited
  end

  def in_order(node = root, visited = [], &block)
    return if node.nil?
    
    in_order(node.left, visited, &block)
    block_given? ? block.call(node) : visited.push(node.value)
    in_order(node.right, visited, &block)

    visited
  end

  def pre_order(node = root, visited = [], &block)
    return if node.nil?
    
    block_given? ? block.call(node) : visited.push(node.value)
    pre_order(node.left, visited, &block)
    pre_order(node.right, visited, &block)

    visited
  end

  def post_order(node = root, visited = [], &block)
    return if node.nil?
    
    post_order(node.left, visited, &block)
    post_order(node.right, visited, &block)
    block_given? ? block.call(node) : visited.push(node.value)

    visited
  end

  def depth(value, node = root, level = 0)
    return nil if node.nil?

    if value < node.value
      depth(value, node.left, level += 1)
    elsif value > node.value
      depth(value, node.right, level += 1)
    else
      return level
    end
  end

  def height(node = root)
    return -1 if node.nil?

    node = find(node) if node.is_a? Integer
    left_height = height(node.left)
    right_height = height(node.right)
    if left_height >= right_height
      return left_height + 1
    else
      return right_height + 1
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
end

data = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

puts data.pretty_print
puts "inserting 2..."
data.insert(2)
puts data.pretty_print

puts "deleting 9..."
data.delete(9)
puts data.pretty_print
puts "deleting 3..."
data.delete(3)
puts data.pretty_print
puts "deleting 6..."
data.delete(6)
puts data.pretty_print
puts "deleting 67..."
data.delete(67)
puts data.pretty_print

#puts "node for value 324: #{data.find(324)}"
#p data

#puts "level order with no block:"
#p data.level_order
#puts "level order with block:"
#data.level_order { |node, c| puts "node #{c}. #{node.value}" }
#data.level_order { |node| puts "doubled: #{node.value * 2}" }

#puts "in order with no block"
#p data.in_order
#puts "in order with block"
#data.in_order { |node| puts "node v:#{node.value}"}

#puts "pre order with no block"
#p data.pre_order
#puts "pre order with block"
#data.pre_order { |node| puts node.value}

#puts "post order with no block"
#p data.post_order
#puts "post order with block"
#data.post_order { |node| puts node.value}

puts "depth level of value 7: #{data.depth(7)}"
puts "depth level of value 5: #{data.depth(5)}"
puts "depth level of value 3: #{data.depth(3)}"

puts "(longest)height of 324: #{data.height(324)}"
puts "(longest)height of 8: #{data.height(8)}"
#puts "(longest)height of 9: #{data.height(9)}"