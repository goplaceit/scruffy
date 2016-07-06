module Scruffy::Layers
  # ==Scruffy::Layers::Line
  #
  # Author:: Brasten Sager
  # Date:: August 7th, 2006
  #
  # Line graph.
  class Line < Base
    
    # Renders line graph.
    #
    # Options:
    # See initialize()
    def draw(svg, coords, options={})
      # Opciones para las lineas que unen los puntos.
      if @options[:only_dots]
        polyline_options = {stroke: 'none', stroke_opacity: 0}
      else
        polyline_options = {stroke: color.to_s, stroke_opacity: 0.35}
      end
      # Controlar el radio de los circulos.
      dot_radius = @options[:dot_radius].nil? ? 2 : @options[:dot_radius]

      # Include options provided when the object was created
      options.merge!(@options)
      
      stroke_width = (options[:relativestroke]) ? relative(options[:stroke_width]) : options[:stroke_width]
      style = (options[:style]) ? options[:style] : ''

      if @options[:limit_lines]
        coords.each_with_index do |coord, index|
          # Linea que une el grafico de barra.
          coord_aux = [coord, [@options[:bar].as_json['meta_coords'][index][:x], @options[:bar].as_json['meta_coords'][index][:height]]]
          svg.polyline( :points => stringify_coords(coord_aux).join(' '), :fill => 'none',:stroke => 'black', 'stroke-width' => relative(0.7) )

          # Linea cabecera.
          coord_linea = [[coord[0] - 5 , coord[1]], [coord[0] + 5 , coord[1]]]
          svg.polyline(points: stringify_coords(coord_linea).join(' '), fill: 'none', stroke: 'black', 'stroke-width' => relative(0.7) )
        end
      else     
        if options[:shadow]
          svg.g(:class => 'shadow', :transform => "translate(#{relative(0.5)}, #{relative(0.5)})") {
            svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'transparent', 
                          :stroke => 'black', 'stroke-width' => stroke_width, 
                          :style => 'fill-opacity: 0; stroke-opacity: 0.35' )
            
            if options[:dots]
              coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last + relative(0.9), :r => stroke_width, 
                                                :style => "stroke-width: #{stroke_width}; stroke: black; opacity: 0.35;" ) }
            end
          }
        end

        svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'none', :stroke => @color.to_s, 
                      'stroke-width' => stroke_width, :style => style  )

        if options[:dots]
          coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last, :r => stroke_width, 
                                            :style => "stroke-width: #{stroke_width}; stroke: #{color.to_s}; fill: #{color.to_s}" ) }
        end
      end
    end # end draw
  end # end class
end