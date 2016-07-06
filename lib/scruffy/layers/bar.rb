module Scruffy::Layers
  # ==Scruffy::Layers::Bar
  #
  # Author:: Brasten Sager
  # Date:: August 6th, 2006
  #
  # Standard bar graph.  
  class Bar < Base
  
    # Draw bar graph.
    # Now handles positive and negative values gracefully.
    def draw(svg, coords, options = {})
      coords.each_with_index do |coord,idx|
        next if coord.nil?
        x, y, bar_height = (coord.first), coord.last, 1#(height - coord.last)
        
          valh = max_value + min_value * -1 #value_height
          maxh = max_value * height / valh #positive area height
          minh = min_value * height / valh #negative area height
          #puts "height = #{height} and max_value = #{max_value} and min_value = #{min_value} and y = #{y} and point = #{points[idx]}"
          if points[idx] > 0
            bar_height = points[idx]*maxh/max_value
          else
            bar_height = points[idx]*minh/min_value
          end
        
        #puts " y = #{y} and point = #{points[idx]}"  
        unless options[:border] == false
          svg.g(:transform => "translate(-#{relative(0.5)}, -#{relative(0.5)})") {
            svg.rect( :x => x, :y => y, :width => @bar_width + relative(1), :height => bar_height + relative(1), 
                      :style => "fill: black; fill-opacity: 0.15; stroke: none;" )
            svg.rect( :x => x+relative(0.5), :y => y+relative(2), :width => @bar_width + relative(1), :height => bar_height - relative(0.5), 
                      :style => "fill: black; fill-opacity: 0.15; stroke: none;" )
          }
        end
        
        # current_colour = color.is_a?(Array) ? color[idx % color.size] : color
        # Cambiar colores de los graficos de barras, con los dados por el tema.
        current_colour = @options[:custom_colors] ? options[:theme].colors[idx].to_s : color.to_s
        
        svg.rect( :x => x, :y => y, :width => @bar_width, :height => bar_height, 
          :fill => current_colour.to_s, 'style' => "opacity: #{opacity}; stroke: none;" )

        @meta_coords << {x: x + (@bar_width / 2), height: y}
      end
    end

    protected
    
      # Due to the size of the bar graph, X-axis coords must 
      # be squeezed so that the bars do not hang off the ends
      # of the graph.
      #
      # Unfortunately this just mean that bar-graphs and most other graphs
      # end up on different points.  Maybe adding a padding to the coordinates
      # should be a graph-wide thing?
      #
      # Update : x-axis coords for lines and area charts should now line
      # up with the center of bar charts.
      
      def generate_coordinates(options = {})
        @bar_width = (width / points.size) * 0.95
        options[:point_distance] = (width - (width / points.size)) / (points.size - 1).to_f

        #TODO more array work with index, try to rework to be accepting of hashes
        coords = (0...points.size).map do |idx|
          next if points[idx].nil? 
          x_coord = (options[:point_distance] * idx) + (width / points.size * 0.5) - (@bar_width * 0.5)

          relative_percent = ((points[idx] == min_value) ? 0 : ((points[idx] - min_value) / (max_value - min_value).to_f))
          y_coord = (height - (height * relative_percent))
          [x_coord, y_coord]
        end
        coords
      end
  end
end