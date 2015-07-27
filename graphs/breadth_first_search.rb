require 'byebug'

module Suite
  module Test1
    class STDIN
      def self.read
        %{1
4 2
1 2
1 3
1}
      end
    end
  end
end

# Responsible for reading STDIN
class Reader
  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
    @pointer = 0
    @testcases = []
  end

  def each_testcase
    testcases.each { |testcase| yield testcase }
  end

  private

  def testcases
    number_of_testcases.times { read_testcase }
    @testcases
  end

  def number_of_testcases
    read_num
  end

  def read_testcase
    edges = []
    number_of_nodes, number_of_edges = read_pair
    number_of_edges.times { edges << Edge.new(*read_pair) }
    start_index = read_num
    @testcases << TestCase.new(number_of_nodes, edges, start_index)
  end

  # Read one line with two space separated integers
  def read_pair
    list = @lines[@pointer].split(' ').map(&:to_i)
    inc_pointer
    list
  end

  def read_num
    num = @lines[@pointer].to_i
    inc_pointer
    num
  end

  def inc_pointer
    @pointer += 1
  end
end

class Edge
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class TestCase
  attr_reader :number_of_nodes, :edges, :start_index

  def initialize(number_of_nodes, edges, start_index)
    @number_of_nodes = number_of_nodes
    @edges = edges
    @start_index = start_index
  end
end

class Writer
  def initialize(stdout)
    @stdout = stdout
    @lines = []
  end

  def add_line(line)
    @lines << line
  end

  def print
    @stdout.print @lines.join("\n")
  end
end

class TriangularMatrix
  def initialize
    @store = []
  end

  def [](x,y)
    if x > y
      index = index_for(x,y)
      @store[index]
    else
      raise IndexError
    end
  end

  def []=(x, y, v)
    if x > y
      index = index_for(x,y)
      @store[index] = v
    else
      raise IndexError
    end
  end

  def index_for(x, y)
    (x * (x + 1)) / 2 + y
  end
end

# Extends array providing default value 0 to all not initialized records
class ZArray < Array
  def [](x)
    if x > size
      for i in (size + 1..x)
        self[i] = 0
      end
    end
    v = super(x)
  end

  def []=(x, v)
    max = size
    super(x, v)
    if size - max > 1
      (max..size - 2).each do |i|
        self[i] = 0
      end
    end
  end
end

class AdjacencyMatrix < TriangularMatrix
  def initialize
    @store = ZArray.new
  end
end

class Graph
  attr_reader :number_of_nodes, :start_index, :adj_matrix

  def initialize(number_of_nodes, edges, start_index)
    @number_of_nodes = number_of_nodes
    @start_index = start_index
    @adj_matrix = AdjacencyMatrix.new
    edges.each { |edge| insert(edge.x, edge.y) }
  end

  # @return [Boolean] Marks whether or not there is a path between two nodes
  def breath_first_search(end_index)
    node_queue = [@start_index]
    loop do
      curr_node = node_queue.pop

      return false if curr_node == nil
      return true if curr_node == end_index

      children = (2..@number_of_nodes).to_a.select do |index|
        edge?(curr_node, index)
      end

      node_queue = children + node_queue
    end
  end

  private

  def insert(x, y)
    x, y = y, x if y > x
    @adj_matrix[x, y] = 1
  end

  def edge?(x, y)
    return false if x == y
    x, y = y, x if y > x
    @adj_matrix[x, y] == 1
  end
end

# Testing purpose
@reader = Reader.new(Suite::Test1::STDIN)

# @reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@reader.each_testcase do |obj|
  @graph = Graph.new(obj.number_of_nodes, obj.edges, obj.start_index)
  (2..4).to_a.each { |i| print @graph.breath_first_search(i) }
end

@writer.print