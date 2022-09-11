-- These functions emulate some of BBC BASIC's drawing commands/features.

-- MY LUA FUNCTION              | BBC BASIC CODE IT EMULATES    | EXPLANATION
-- -----------------------------|-------------------------------|--------------------------------------------
-- bbc_vdu19(logical,physical)  | VDU 19,logical,physical,0,0,0 | Change the colour palette.
-- bbc_gcol(c)                  | GCOL 0,c                      | Set the current graphics foreground colour.
-- bbc_move(x,y)                | MOVE x,y                      | Move the graphics cursor to position x,y.
-- bbc_draw(x,y)                | DRAW x,y                      | Move the graphics cursor to x,y and draw a line from the previous position to the new position.
-- bbc_plot85(x,y)              | PLOT 85,x,y			| Draw a filled triangle.
-- bbc_print(string)		| VDU 5: PRINT ;string$;        | Draw text in the current graphics foreground colour at the current graphics cursor position. 

require "drawscaledtext"

bbc_points_x = {}
bbc_points_y = {}
bbc_points_p = 0
for i=0, 2, 1 do
 bbc_points_x[i]=0
 bbc_points_y[i]=0
end

bbc_full_palette = { {0,0,0,1}, {1,0,0,1}, {0,1,0,1}, {1,1,0,1}, {0,0,1,1}, {1,0,1,1}, {0,1,1,1}, {1,1,1,1} }
bbc_current_palette = { 0, 1, 3, 7 }
bbc_current_palette_num_colours = 4
bbc_current_colour = 3

function bbc_vdu19( logical, physical )
 logical  = math.abs(math.floor(logical  % bbc_current_palette_num_colours))
 physical = math.abs(math.floor(physical % 8))
 bbc_current_palette[logical+1]=physical
 if logical==0 then
  love.graphics.setBackgroundColor( bbc_full_palette[physical+1] )
 end
end

function bbc_gcol( c )
 bbc_current_colour = math.floor( math.abs( c % bbc_current_palette_num_colours ) )
 local actual_colour_for_love2d
 actual_colour_for_love2d = bbc_full_palette[ bbc_current_palette[ bbc_current_colour + 1 ] + 1 ]
 love.graphics.setColor( actual_colour_for_love2d )
end

function bbc_move( x, y )
 bbc_points_p = math.floor( (bbc_points_p+1) % 3 )
 -- the x,y position is converted to scale the BBC Micro's 1280x1024 virtual resolution to fit the size of Love2d's window.
 -- the y coordinate is also converted to work with love2d's top-down y coordinate format, vs BBC BASIC's bottom-up format
 bbc_points_x[bbc_points_p] = x*(love.graphics.getWidth()/1280)
 bbc_points_y[bbc_points_p] = (1024-y)*(love.graphics.getHeight()/1024)
end

-- initialise the 'MOVE' points array
for i=0, 2, 1 do
 bbc_move(0,0)
end

function bbc_draw( x, y )
 local x1,y1
 x1=bbc_points_x[bbc_points_p]
 y1=bbc_points_y[bbc_points_p]
 bbc_move(x,y)
 love.graphics.line( x1,y1, bbc_points_x[bbc_points_p],bbc_points_y[bbc_points_p] )
end

function bbc_plot85( x, y )
 bbc_move(x,y)
 love.graphics.polygon( "fill",
                        bbc_points_x[0], bbc_points_y[0],
                        bbc_points_x[1], bbc_points_y[1],
                        bbc_points_x[2], bbc_points_y[2] )
end

function bbc_print( string )
 drawscaledtext( bbc_points_x[bbc_points_p], bbc_points_y[bbc_points_p], 8*(love.graphics.getWidth()/1280)/2, 8*(love.graphics.getHeight()/1024)/2, string )
end
