module Algorithm
  module BreathFirstSearch
    # Traverse the graph applying the algorithm Breath-First Search
    # Exploiting traversal is possible through serveral hooks
    # @param start [Fixnum] The node from which to start to traverse the graph
    # @see hook_process_vertex_early
    # @see hook_process_vertex_late
    # @see hook_process_edge
    def traverse(start)
      reset_vertices
      queue = Queue.new(start)
      @vertices[start].status = Vertex::DISCOVERED
      process_vertex_start(start)
      loop do
        x = queue.dequeue
        parent = @vertices[x]
        parent.status = Vertex::PROCESSED
        parent.each_edge do |edge|
          y = edge.y
          vertex = @vertices[y]
          process_edge(x, y) if !vertex.processed? || @directed
          if vertex.undiscovered?
            queue.enqueue(y)
            vertex.update_attributes(status: Vertex::DISCOVERED, parent: parent)
          end
        end
        break if queue.empty?
      end
    end

    # @param value [Fixnum]
    def process_vertex_start(value)
    end

    # @param x [Fixnum] the start of the edge
    # @param y [Fiynum] the end of the edge
    def process_edge(x, y)
    end
  end
end
