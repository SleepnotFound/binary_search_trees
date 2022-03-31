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

puts "node for value 324: #{data.find(324)}"
#p data

puts "level order with no block:"
p data.level_order
puts "level order with block:"
data.level_order { |node, c| puts "node #{c}. #{node.value}" }
data.level_order { |node| puts "doubled: #{node.value * 2}" }