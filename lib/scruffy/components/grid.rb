module Scruffy
  module Components
    class Grid < Base
      attr_accessor :markers
      
      include Scruffy::Helpers::Marker
      
      def draw(svg, bounds, options={})
        markers = (options[:markers] || self.markers) || 5
        
        # Revisar
        # stroke_width = options[:stroke_width] 
        stroke_width = 0.5
        
        colour = options[:theme].grid || options[:theme].marker
        
        each_marker(markers, options[:min_value], options[:max_value], bounds[:height], options, :value_formatter) do |label, y|
          svg.line(:x1 => 0, :y1 => y, :x2 => bounds[:width], :y2 => y, :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
        end
        
        #add a 0 line
        y = (options[:max_value] * bounds[:height])/(options[:max_value] - options[:min_value])
        svg.line(:x1 => 0, :y1 => y, :x2 => bounds[:width], :y2 => y, :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
        
      end
    end
    
    class VGrid < Base
      attr_accessor :markers
      
      include Scruffy::Helpers::Marker
      
      def draw(svg, bounds, options={})
        colour = options[:theme].grid || options[:theme].marker
        
        if options[:graph].point_markers #get vertical grid lines up with points if there are labels for them
          point_distance = bounds[:width] / (options[:graph].point_markers.size).to_f
          # Revisar
          # stroke_width = options[:stroke_width]
          stroke_width = 0.5
          (0...options[:graph].point_markers.size).map do |idx| 
            x = point_distance * idx  + point_distance/2
            svg.line(:x1 => x, :y1 => 0, :x2 => x, :y2 => bounds[:height], :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
          end
          #add the far right and far left lines
          svg.line(:x1 => 0, :y1 => 0, :x2 => 0, :y2 => bounds[:height], :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
          svg.line(:x1 => bounds[:width], :y1 => 0, :x2 => bounds[:width], :y2 => bounds[:height], :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
        else
            
          markers =  (options[:key_markers] || self.markers) || 5 #options[:point_markers].size#
          stroke_width = options[:stroke_width]
          each_marker(markers, options[:min_key], options[:max_key], bounds[:width], options, :key_formatter) do |label, x|
            svg.line(:x1 => x, :y1 => 0, :x2 => x, :y2 => bounds[:height], :style => "stroke: #{colour.to_s}; stroke-width: #{stroke_width};")
          end
          
        end
      end
    end
  end
end

