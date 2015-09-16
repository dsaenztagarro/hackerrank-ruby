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
      @vertices[start] = Vertex::DISCOVERED
      loop do
        value = queue.dequeue
        parent = @vertices[value]
        parent.status = Vertex::PROCESSED
        [*@edges[value]].each do |edgenode|
          vertex = @vertices[edgenode.y]
          hook_process_edge if !vertex.processed? || @directed
          if !vertex.discovered?
            queue.enqueue(edgenode.y)
            vertex.status = Vertex::DISCOVERED
            vertex.parent = parent
          end
        end
        break if queue.empty?
      end
    end

    # @param value [Fixnum]
    def hook_process_vertex_early(value)
    end

    # @param value [Fixnum]
    def hook_process_vertex_late(value)
    end

    # @param x [Fixnum] the start of the edge
    # @param y [Fiynum] the end of the edge
    def hook_process_edge(x, y)
    end
  end
end