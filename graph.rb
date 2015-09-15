#!/usr/bin/env ruby
# 
# -> Display random numbers (from stdin) as a live ASCII bar graph. 
# 
# Take a look at this Screenshot:
# +--------------------------------------------------------------------+
# |  |   |        |  |         |  |      |          ||   |        |    | 
# |  |   |     || | ||   |     || | ||   |     || | ||   |  |  || | |  |                                                      
# |  | | |  || || |||| | |  || || |||| | |  || || |||| | |  || || |||  |                                                      
# |  | | |  || || |||| | |  || || |||| | |  || || |||| | |  || || |||  |                                                      
# |  | | | |||||| |||| | | |||||| |||| | | |||||| |||| | | |||||| |||  |                                                      
# |  | ||||||||||||||| ||||||||||||||| ||||||||||||||| ||||||||||||||  |                                                      
# |  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  |                                                      
# |  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  |                                                      
# |  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  |                                                      
# |  Max Value: 78                                                     |
# |  Min Value: 23                                                     |
# +--------------------------------------------------------------------+
# 
# Copyright (c) 2007 by Neelakanth Nadgir. All rights reserved.
#
# Copyright (c) 2012 by Marcelo Leal. All rights reserved.
#

class HorizBar
  # Usint tput to know the colsxlines...
  WIDTH = (`tput cols`.to_i - 3)
  HEIGHT = (`tput lines`.to_i - 3)
  def initialize(array)
    @values = array
  end
  def draw
    #Adjust X axis when there are more than WIDTH cols
    if @values.length > WIDTH then
      old_values = @values;
      @values = []
      0.upto(WIDTH - 1){ |i| @values << old_values[i * old_values.length/WIDTH]}
    end
    max = @values.max
    min = @values.min
    # initialize display with blanks
    display = Array.new(HEIGHT).collect { Array.new(WIDTH, ' ') }
    @values.each_with_index do |e, i|
      num= e * HEIGHT / max
      (HEIGHT - 1).downto(HEIGHT - 1 - num){|j| display[j][i] = '|'}
    end    
    display.each{|ar| ar.each{|e| putc e}; puts "\n"} #now print
    # Prints the Max and Min values of the array to quick reference...
    printf "Max Value: %d\n", max
    printf "Min Value: %d\n", min
  end
end

##### Main Program #####
# Some variables...
counter = 1
a = []

# Exit cleanly when the world comes to an end...
trap("SIGINT") { throw :ctrl_c }

catch :ctrl_c do
 begin
   # The game (picking data from stdin)...
   $stdin.each_line { |line| 
          a << line.to_i 
          HorizBar.new(a).draw
   }
   rescue Exception
 end
end
# So, got something? ;-)
