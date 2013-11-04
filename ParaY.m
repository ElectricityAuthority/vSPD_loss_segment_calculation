function [yy] = ParaY(x,y);	%I want 0:N, but am forced to 1:N + 1.
%Given a parabola y = x^2 and a set of line segments joining (x,y),
%leaving the x values fixed, adjust the y-values to minimise ParaQuat(x,y).
%Nominally, points 0:N, but matlubber starts indexing with one.
n = length(x) - 1;		%The first and last points are fixed.
dy = 0.01;			%Hopefully, a suitable step.
while dy > 0.00001		%Hopefully, enough, and not too much.
 straddle(2:n) = false;		%Actually, once started, it should continue.
 for iy = 2:n			%Consider the successive y-values.
  d1 = Paraquat(x,y);		%Value at the central position.
  yy = y;			%Now go for + step and - step.
  yy(iy) = y(iy) - dy; d0 = Paraquat(x,yy);	%Back one step.
  if d0 < d1			%An improvement already?
    y(iy) = y(iy) - dy;		%Yes, go there at once.
   else				%Otherwise, consider the other side.
    yy(iy) = y(iy) + dy; d2 = Paraquat(x,yy);	%Forward one step.
    if d2 < d1			%Immediate improvement?
      y(iy) = y(iy) + dy;	%Yes. Step, since extrapolation is risky.
     else			%Otherwise, a straddle! Yay!
      straddle(iy) = true;	%So, declare this.
      t = (d0 - d2)/(d0 - 2*d1 + d2)/2;	%Find the minimum for a parabola fitted to t = (-1, 0, +1) and f(t) = (d0,d1,d2).
      y(iy) = y(iy) + t*dy;	%Rescale t from 0 to the move from the central y-position.
    end;			%Once a straddle is found, confidence rises!
  end;				%Enough looking about.
  %ParaDiddle(x,y);	incomprehensible complaint that y is undefined in ParaDiddle.
 end;				%On to another y-variable.
 if all(straddle(2:n)), dy = dy/2; end;	%Is everybody happy?
end;				%Hopefully, this won't loop forever wandering off to outer infinity.
yy = y;	%I'd prefer to fiddle y in place.
