function E = Paraquat(x,y);	%Returns the merit of (x,y) for ParaWhat.
%Approximate a parabola with some straight lines.
%Damn matlubber doesn't allow a array to have index zero.
%Weights in hg, centre positions in hstep, hn of them.
%Numerical integration of weight*f(x) via the midpoint method with hn midpoints.
global X Y hn hg hstep;
E = 0;
n = length(x);		%mutlubber points 1:n cover x = [0:1].
if length(hg) > 1	%A weighting histogram?
  for i = 2:n			%Step along the pieces.
   x1 = x(i - 1); x2 = x(i);	%The bounds of the piece.
   m = (y(i) - y(i - 1))/(x2 - x1);	%Slope.
   c = y(i) - m*x2;			%Intercept.
   w1 = fix(x1*hn) + 1;			%Start step, counting from one, not zero.
   w2 = min(hn,fix(x2*hn) + 1);		%min because x = 1 would give hn...
   e = (w1/hn - x1)      /hn *hg(w1)*(x1^2 - (m*x1 + c))^2 ...
     + (x2 - (w2 - 1)/hn)/hn *hg(w2)*(x2^2 - (m*x2 + c))^2;	%Pro-rata parts of the first and last step.
   for j = w1 + 1:w2 - 1	%The fully-included steps.
     e = e + hg(j)*(hstep(j)^2 - (m*hstep(j) + c))^2;	%Each at their midpoint.
   end;				%On to the next.
   %disp(['x1=',num2str(x1),',x2=',num2str(x2),',w1=',num2str(w1),',w2=',num2str(w2),'; e=',num2str(e)]);
   E = E + e;			%Over x(i - 1) to x(i).
  end;				%Next segment.
  E = E/hn;		%Evaluation count is hn. The width is 1.
 else			%Otherwise, no messing with weights.
  for i = 2:n			%Step along the pieces.
   m = (y(i) - y(i - 1))/(x(i) - x(i - 1));	%Slope.
   c = y(i) - m*x(i);				%Intercept.
   E = E + Diff2(x(i - 1),x(i),m,c);		%Over x(i - 1) to x(i).
  end;				%Next segment.
end;			%Enough choices.

%End the lead function. Fall into the subfunction.

function err = Diff2(x1,x2,m,c);	%This might do better as a numerical integration!
%Integrate the square of the difference: [x^2  - (m*x + c)]^2.
%disp(['x1=',num2str(x1),',x2=',num2str(x2),'m=',num2str(m),',c=',num2str(c)]);
e2 =  ((((x2/5 - m/2)*x2 + (m^2 - 2*c)/3)*x2 + c*m)*x2 + c^2)*x2;
e1 =  ((((x1/5 - m/2)*x1 + (m^2 - 2*c)/3)*x1 + c*m)*x1 + c^2)*x1;	%Just think of all the cancellation.
err = e2 - e1;	%Whee! Even more cancellation!
%End.
