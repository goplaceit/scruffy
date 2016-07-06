module Scruffy::Renderers
  class Standard < Empty
    
    def define_layout(options = {})
      super(options) do |components|
        components << Scruffy::Components::Title.new(:title, :position => [5, 2], :size => [90, 7])
        components << Scruffy::Components::Viewport.new(:view, :position => [2, 26], :size => [90, 66]) do |graph|
          graph << Scruffy::Components::ValueMarkers.new(:values, :position => [0, 2], :size => [8, 89])
          graph << Scruffy::Components::Grid.new(:grid, :position => [10, 0], :size => [90, 89], :stroke_width => 1)
          graph << Scruffy::Components::VGrid.new(:vgrid, :position => [10, 0], :size => [90, 89], :stroke_width => 1) if options[:vertical_grid]
          graph << Scruffy::Components::DataMarkers.new(:labels, :position => [10, 92], :size => [90, 8])
          graph << Scruffy::Components::Graphs.new(:graphs, :position => [10, 0], :size => [90, 89])
        end
        components << Scruffy::Components::Legend.new(:legend, :position => [5, 13], :size => [90, 6])
      end
    end
    
    protected
      def hide_values
        super
        component(:view).position[0] = -10
        component(:view).size[0] = 100
      end
    
      def labels
        [component(:view).component(:labels)]
      end
    
      def values
        [component(:view).component(:values)]
      end
      
      def grids
        [component(:view).component(:grid),component(:view).component(:vgrid)]
      end
  end
end