require 'gnuplot'

Gnuplot.open do |gp|
  Gnuplot::SPlot.new( gp ) do |s|

    s.mouse
    s.view
    #s.arbitrary_lines << 'pause mouse keypress'
    s.grid 'nopolar'
    s.grid 'xtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics'
    s.grid 'layerdefault   linetype 0 linewidth 1.000,  linetype 0 linewidth 1.000'
    s.samples '21, 21'
    s.isosamples '11, 11'
    s.title "3d gnuplot demo" 

    s.xlabel "x axis" 
    #s.xlabel 'character -3, -2, 0 textcolor lt -1 norotate'
    s.xrange '[ -10.0 : 10.0 ] noreverse nowriteback'

    s.ylabel "y axis" 
    #s.ylabel 'character 3, -2, 0 textcolor lt -1 rotate by 90'
    s.yrange '[ -10.0 : 10.0 ] noreverse nowriteback'

    s.zlabel "z axis" 
    #s.zlabel 'character -5, 0, 0 textcolor lt -1 norotate'

    s.data << Gnuplot::DataSet.new( 'sin(x)+cos(y)' ) do |ds|
      #ds.with = 'lines'
      ds.with = 'pm3d'
      ds.linewidth = 1
    end

  end

  sleep 10

end

