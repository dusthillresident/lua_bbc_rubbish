
require "emulated_bbc_functions"

-------------------------------------------------------------------------------------------------------------
-- Lua/Love2d version of a BBCMicroBot tweet                                                               --
-- Please see 'reference_bbc_code.txt' for the original BBC BASIC code with comment explaning how it works --
-------------------------------------------------------------------------------------------------------------

function proc_c( x, y, r )
 if math.abs(r)<1 then
  r = 1
 end
 for i=-r, r, 1 do
  l = r * math.sin( math.acos( i / r ) ) 
  bbc_move( x-l, y+i )
  bbc_draw( x+l, y+i )
 end
end

function proc_C( X, Y, L )
 for J=0, 15, 1 do
  for I=0, 15, 1 do
   M = J/16
   A = I/16*math.pi*2 + J/15*math.pi
   proc_c( X+M*L*math.cos(A), Y+M*L*math.sin(A), L*(1-M^2)*0.04 )
  end
 end
 -- In the original program I use the XOR plotting mode, that's not possible in Love2d,
 -- so as the closest possible thing we can do, I just select the inverse of the currently selected colour
 bbc_gcol( bbc_current_palette_num_colours-1 - bbc_current_colour ) 
 bbc_move( X-80, Y+10 )
 bbc_print("HELLO")
end

-- in the original BASIC code, this is the main body of the program
function mainbody()
 bbc_vdu19(0,4)
 local R, h
 R = 100
 h = 1024
 bbc_gcol( 1 )
 for x=0, 1300, R do
  for y=0, h, R do
   proc_c( x + math.floor((y/R) % 2) * R * 0.5, y, (1-y/h)*R*0.7 ) 
  end
 end
 bbc_gcol( 2 )
 proc_C( 300, 750, 512 )
 bbc_gcol( 3 )
 proc_C( 960, 300, 512 )
end

-----------------------------------------------------------------------------
-- End of the translated BBC program. The stuff beyond here is love2d junk --
-----------------------------------------------------------------------------

function love.load()
 -- If I enable this line, the colours get totally messed up. I don't understand why this happens. It might only be a problem on my specific computer.
 --love.window.setMode( 1280,1024,{resizable=true} )
end

function love.draw()
 -- I know this gets called every frame and is probably not the best way to simply just get my thing on the screen,
 -- but this is just the only way I know how to do it right now.
 -- Lemme know what the more efficient way is.
 -- However it seems like Love2d has some issue running on my computer where the first few frames are totally messed up,
 --  so if I only draw once after starting up, I just see garbled glitchy mess,
 --   so for now doing it this way seems to be the only way I can see stuff
 mainbody()
 -- Some crap I had here while I was testing stuff..
 --love.graphics.setColor( bbc_full_palette[2] )
 --love.graphics.line( -500,0,500,500)
 --bbc_move(0,0)
 --bbc_move(500,0)
 --bbc_plot85(0,500)
 --bbc_draw(500,500)
 --bbc_vdu19(0,4)
end