require_relative 'tree.rb'

array = Array.new(15) { rand(1..100) }
data = Tree.new(array)

puts "is tree balanced?: #{data.balanced?}"

puts "level order with no block: #{data.level_order}"
puts "level order(each times 2) with block: #{data.level_order { |node| node.value * 2 }}"

puts "in order with no block: #{data.in_order}"
puts "in order with block: #{data.in_order { |node| node.value * 2 }}"

puts "pre order with no block: #{data.pre_order}"
puts "pre order with block: #{data.pre_order { |node| node.value * 2 }}"

puts "post order with no block: #{data.post_order}"
puts "post order with block: #{data.post_order { |node| node.value * 2 }}"

data.pretty_print

puts "adding additional nodes."
20.times { data.insert(rand(1..100))}
20.times { |i| data.insert(i + 1)}
data.pretty_print

puts "is tree balanced?: #{data.balanced?}"
puts "rebalancing tree..."
data.rebalance
puts "is tree balanced?: #{data.balanced?}"

puts "level order with no block: #{data.level_order}"
puts "in order with no block: #{data.in_order}"
puts "pre order with no block: #{data.pre_order}"
puts "post order with no block: #{data.post_order}"