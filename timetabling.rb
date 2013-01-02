require 'graphviz'
g = GraphViz.new( :G, :type => :graph )
def file
  @file ||= File.readlines("C:\\edges.txt")
end

def header
  @header ||= file.take(1)[0]
end

def number_of_nodes
  @number_of_nodes ||= header.split(" ")[0].to_i
end

def create_adjacency_matrix (g)
  adjacency_matrix = [].tap { |m| number_of_nodes.times { m << Array.new(number_of_nodes) } }
  file.drop(1).map { |x| x.gsub(/\n/, "").split(" ").map(&:to_i) }.each do |(node1, node2, weight)|
    adjacency_matrix[node1 - 1][node2 - 1] = weight
    adjacency_matrix[node2 - 1][node1 - 1] = weight
    v1 = g.add_nodes((node1 -1).to_s)
    v2 = g.add_nodes((node2 -1).to_s)
    g.add_edges(v1, v2, :label => weight.to_s)
  end
  adjacency_matrix
end
def degree(a, i)
  return a[i].select {|x| x and x > 0 }.size
end
a = create_adjacency_matrix(g)

Li = [];
Node = {};
puts '   1 2 3 4 5'
a.each_with_index do |av,i|
	Node = {}
	Node[:degree] = degree(a, i);
	Node[:weight] = 0;
	Node[:index] = i;
	
	str = ''
	av.each_with_index do |avv,j|
		str +=  avv.to_s + '  '
		Node[:weight] += avv.to_i;
	end
	Li.push(Node);
	
	puts (i+1).to_s + ': ' + str
end

Li.sort_by!  {  |x|  [-x[:degree],-x[:weight],x[:index]]}
puts Li
g.output(:png => "helloworld.png")
