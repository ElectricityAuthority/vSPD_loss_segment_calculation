function [xd,err,r] = ParaDiddle(f,x,y)	%Assistant to ParaWhat.
%xd=[];
%err=[];
%Draw figure f of a parabola depicted by (X,Y)
%Approximated by line segments joining (x,y),
%With a plot of the difference between the two.
 global X Y hn hg hstep;
 n = length(x) - 1;		%Fence and post stuff.
 e = Paraquat(x,y);		%Odd behaviour if no temporary value is used, or the %f gibberish is attempted.
 figure(f); clf; hold 'on';	%Start the gibberish.
 title([int2str(n),' piece fit, demerit ',num2str(e)]);
 plot(X,Y,'r');			%Show the parabola.
 plot(x,y,'k');			%Show the state.
 nn = 66;			%Seems enough for each piece.
 xd = zeros(1,n*nn + 1); yd = zeros(1,n*nn + 1);	%Prepare for some points.
 l = 0;				%None so far.
 for i = 1:n			%Step through the line segments.
  xi = x(i);			%The segment's start x-position.
  dx = x(i + 1) - xi;		%The advance to the end x-position. Never zero!
  m = (y(i + 1) - y(i))/dx;	%The slope of the line.
  c = y(i) - m*xi;		%Ready for y = mx + c.
  for j = 0:nn - 1		%Include the initial position.
   l = l + 1;			%Another point to the list.
   xd(l) = xi + j*dx/nn;	%The position in this segment.
   yd(l) = (xd(l)^2 - (m*xd(l) + c));	%Parabola vs. line segment there.
  end;				%On to the next position.
 end;				%On to the next piece.
 l = l + 1;			%At the end, include the last position.
 xd(l) = x(n + 1);		%Since no piece continues onwards.
 yd(l) = xd(l)^2 - (m*xd(l) + c);	%The last difference is at the last x.
 [how,err,r] = ParaDiff(xd,yd,'g');	%Show the differences.
 if length(hg) <= 1		%Do I have some weights?
   legend('x^2','mx + c',how,'Location','NorthWest');	%Nope.
  else				%But if I have some, here we go.
   plot(hstep,hg,'b');		%Show the weights. hstep now holds centre positions.
   yd = zeros(1,hn);		%Now for the weighted differences.
   for i = 1:n			%Here we go again.
    x1 = x(i); x2 = x(i + 1);	%The segment bounds.
    m = (y(i + 1) - y(i))/(x2 - x1);	%The straight line
    c = y(i) - m*x1;			%Parameters.
    w1 = fix(x1*hn) + 1;	%The segment's start in steps.
    w2 = min(hn,fix(x2*hn));	%I'll be using middles of the steps.
    for j = w1:w2		%Thus.
     yd(j) = hg(j)*(hstep(j)^2 - (m*hstep(j) + c));	%At the middle of the step.
    end;			%The last w2 = hn.
   end;				%On to the next segment.
   [how2,err,r] = ParaDiff(hstep,yd,'c');	%Reveal, rescaled also as needed.
   legend('x^2','mx + c',how,'Weight',['W×',how2],'Location','North');	%Blah.
 end;				%So much for th differences.
 plot([0 1],[0.5 0.5],'g');	%The "zero" line for the differences.
 %l = 0;				%Now for some tick marks the way I want them.
 %for i = 1:length(x);		%One for eaxh x-position.
 % l = l + 1; xd(l) = x(i); yd(l) = 0.5;	%Start a tick.
 % l = l + 1; xd(l) = x(i); yd(l) = 0.49;%End a tick.
 % l = l + 1; xd(l) = NaN; yd(l) = NaN;	%Split a tick.
 %end;				%On to the next point.
 %plot(xd(1:l),yd(1:l),'k');	%Splat that.
%End;


 function [how,err,r] = ParaDiff(xd,yd,colour);
  d = max(abs(yd));		%The mostest encountered. Surely not zero.
  %keyboard
  r = 1; f = 5;			%Now for some rescaling.
  while r*d < 0.1		%Too small to see a reasonable wiggle?
   r = r*f;			    %Yes. Crank up the scale.
   f = 7 - f;			%Alternate 5 and 2.
  end;				    %Thus not straight powers of ten.
  err = r*yd;
  plot(xd,err + 0.5,colour);	%Plot all rescaled and repositioned.
  %keyboard
  if r == 1			%Alright, any rescaling?
    how = 'Diff';		%No. Oh well.
   else				%But instead,
    how = ['Diff ×',int2str(r)];	%This much.
  end;				%So much for the annotation.
  how = [how,' + 0·5'];		%Not forgetting the offset.
 %End.

