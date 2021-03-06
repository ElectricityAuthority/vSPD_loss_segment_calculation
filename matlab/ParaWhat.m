%Approximate a parabola over 0:1 with a sequence of straight lines.
%Notionally, x(0) = 0, and x(N) = 1, with the interior positions being adjustable.
%But damn mutlubber doesn't allow an array to have index zero.
%So instead of the array being 0:N it will have to be 1:N + 1.
%The basic ploy is, given a position X, evaluate at X + dx and X - dx,
%and find the minimum of a parabola fitted to those three positions.
%Concocted by R.N.McLean (whom God preserve) August MMXI.
clear merit;			%This would be good.
global X Y hn hg hstep;		%(X,Y) needed by ParaDiddle.
X = 0:1/2048:1; Y = X.^2;	%The parabola. Odd wobbles for say 1/512.

%Contemplate a weighting possibility to keep Dave entertained.
if ~exist('Values','var')	%Dave wants to play with weighting based on popularity.
  disp('No sign of a "Values" array of values in 0:1');	%But if there are no values, no play.
 else				%Otherwise, we have some values.
  nv = length(Values);		%How many?
  vmin = min(Values);		%Damn mutlub
  vmax = max(Values);		%thus makes multiple passes
  vavg = sum(Values)/nv;	%rather than one compound pass.
  disp([int2str(nv),' values: ',num2str(vmin),' to ',num2str(vmax),', Avg ',num2str(vavg)]);
  if vmin < 0 | vmax > 1	%Beware Daves bearing data.
   disp('Values not in 0:1!');	%Grr.
   return;			%Be off.
  end;				%Otherwise, start some messing.
  hn =  1000;			%A suitably fine division.
  hstep = 0:1/hn:1;		%This includes the ends, so 1:hn + 1.
  hg = histc(Values,hstep);	%Count up a histogram of those values.
  hg(hn) = hg(hn) + hg(hn + 1);	%Idiot behavior at the end.
  hg = hg(1:hn);		%Disappear the last value.
  hstep = hstep(1:hn) + 0.5/hn;	%Middles of the hn intervals spanning (0:1).
  if hg(1) > 6*hg(2)		%As seen, there are a lot of dubious low values.
   hh = hg(4) - hg(3);		%These looked proper, though.
   hg(2) = hg(3) - hh;		%So extrapolate the first two points back
   hg(1) = hg(2) - hh;		%To scrag the observed troublemakers.
   disp('Hic');			%This is not good.
  end;				%But ad-hoc is the style.
  %for hh = 1:6			%Now smooth the sequence somewhat.
   %hg(2:end - 1) = (hg(1:end - 2) + hg(2:end - 1) + hg(3:end))/3;	%Not introducing a l-r bias.
  %end;				%Another go?
  hg = hg/max(hg);		%Convert to reasonable values, avoiding the legend on the plot-to-come.
  clear hh h nv vmin vmax vavg;	%Cast aside the serfs.
end;				%The weighting scheme is in hg.

%Commence, in full for 1:N segments.
for N = 12;			%Just for Dave, some variability.
 clear e0 en x y xx yy x0 y0 dx xd yd straddle;
 x = (0:1/N:1);			%This includes the bounds. So, N + 1 values.
 x(1) = 0; x(N + 1) = 1;	%Fix x0 and xn in case of trial initialisations. Add one for mutlubber.
 y = x.^2;			%Initial positions are on the parabola.
 %keyboard
 [xd,err] = ParaDiddle(1,x,y);		%Draw the picture.
 disp(['Start x= ',num2str(x)]); disp(['Start y= ',num2str(y)]);
 e0 = Paraquat(x,y);		%Integral of (parabola - line)**2.
 disp(['N=',int2str(N),', err=',num2str(e0)]);
 x0 = x; y0 = y;		%Save the starting positions.
%Plot a surface for the first two moveable positions x1 and x2 (mutlub x(2) and x(3))
%Require x2 < x3 as x2 >= x3 is silly. Add one for mutlubber.
%Require x2 > x1 as x2 >= x1 is silly. Add one for mutlubber.
%Require x1 > x0 as x1 <= x0 is silly. Add one for mutlubber.
 xx = x;		%A copy to mess with.
% if N == 2		%One piece means no interior points to shift.
%   figure(2); clf;		%Two pieces means one moveable point, so one-dimension.
%   clear yy zz;			%So I can plot both x and y for this case.
%   yy(1) = 0; yy(3) = 1;	%The interior point is to be fiddled.
%   nG = 50; 			%Steps.
%   zz = zeros(nG,nG);		%Preparation.
%   zz(1:nG,1:nG) = NaN;		%Scrag.
%   for ix = 1:nG - 1		%I want (0:1), not [0:1].
%    xx(2) = ix/nG;		%So one step on from zero, ending one step short of 1.
%    for iy = 1:nG - 1		%Likewise for y.
%     yy(2) = iy/nG;		%Righto, (xx,yy) are ready.
%     zz(iy,ix) = Paraquat(xx,yy);	%The object! Or should it be zz(ix,iy)?
%    end;			%Next y-trial.
%   end;				%Next x-trial.
%   surf(zz);			%Actually, "PlotSurface". Damnit.
%   title('2 piece');
%   xlabel('x'); ylabel('y'); zlabel('Err');
%   set(gca,'xtick',[0:0.1:1]*nG); set(gca,'xticklabel',[0:0.1:1]*1);
%   set(gca,'ytick',[0:0.1:1]*nG); set(gca,'yticklabel',[0:0.1:1]*1);
%  elseif N > 2			%I shall consider only the first two moveable x-positions, and no y-positions.
%   nG = 48;			%Grid for the surface.
%   zz = zeros(nG,nG);		%Prepare the array.
%   zz(1:nG,1:nG) = NaN;		%Scrag the lot.
%   xmax = x(4);			%Available span is (0:x3). Add one for mutlubber.
%   dx = xmax/nG;		%Step size for the grid.
%   for ix2 = 2:nG - 1		%Start x2 at two steps in, so that x1 can start at step one.
%    xx(3) = ix2*dx;		%The second moveable x-value.
%    for ix1 = 1:ix2 - 1		%Steps after x0 and before x2 since x1 < x2 is required.
%     xx(2) = ix1*dx;			%The first moveable x-value.
%     yy = xx.^2;			%Start on the parabola.
%     yy = ParaY(xx,yy);			%Adjust the y-values: only x-behaviour is plotted.
%     zz(ix2,ix1) = Paraquat(xx,yy);	%The error.
%    end;			%On to the next x1.
%   end;				%On to the next x2.
%   figure(2); clf; surf(zz);	%PlotSurface, of course.
%   set(gca,'xtick',[0:0.1:1]*nG); set(gca,'xticklabel',[0:0.1:1]*xmax);	%Alignment and out-by-one
%   set(gca,'ytick',[0:0.1:1]*nG); set(gca,'yticklabel',[0:0.1:1]*xmax);	%Is unclear.
%   xlabel('x1'); ylabel('x2'); zlabel('Err');
%   title(['Varying x_1, x_2 between 0 and ',num2str(xmax)]);
% end;			%Enough surface stuff.

%Find optimum values for the interior x and y positions.
%Adjust x-values only after y-values have been optimised.
 clear tries Movie pic;
 tries = 0; pic = 0;		%No effort.
 if N > 1			%Is there something to fiddle?
  [xd,err] = ParaDiddle(3,x,y);		%Show the starting state, which may be deliberately poor.
  y = ParaY(x,y);		%Fiddle the y-values for these x-values.
  [xd,err] = ParaDiddle(3,x,y);		%Whatever the x-values, the y-values are now good.
  dx = 0.01;			%Step in the x-variables.
  while dx > 0.0001		%Enough to find the minima, I hope.
   tries = tries + 1;		%Very trying.
   straddle(2:N) = false;	%Two styles of search.
   yy = y;			%A copy to mess with.
   for ix = 2:N			%Points 0 and N are fixed, but I must use 1 and N + 1.
    d1 = Paraquat(x,y);		%Value at the central (x,y) position.
    xx = x;			%Prepare a working position.
    xx(ix) = x(ix) - dx;	%Back one step along the selected x-term.
    yy = ParaY(xx,yy);		%Adjust all the y-positions.
    d0 = Paraquat(xx,yy);	%Value at x-offset -1.
    if d0 < d1			%Is it better already?
      x(ix) = x(ix) - dx;	%Yes. Go there at once.
      %disp(['x',num2str(ix),' back:',num2str(x(ix)),' d0=',num2str(d0),',d1=',num2str(d1)]);
      y = yy;			%Accept the associated y-values.
     else			%But if it is not better than the middle position, d1,
      xx(ix) = x(ix) + dx;	%Forward one step along the same x-term.
      yy = ParaY(xx,yy);	%Fiddle all the y-values.
      d2 = Paraquat(xx,yy);	%The result.
      if d2 < d1		%Strictly better?
        x(ix) = x(ix) + dx;	%Yes. Go there at once.
        %disp(['x',num2str(ix),' onwd:',num2str(x(ix)),' d1=',num2str(d1),',d2=',num2str(d2)]);
        y = yy;			%Accept the associated y-values.
       else			%Otherwise d0 >= d1 >= d2, and I'm not expecting =.
        straddle(ix) = true;	%Yay! I now have confidence!
        t = (d0 - d2)/(d0 - 2*d1 + d2)/2;	%Lowest x-position in steps -1 0 +1.
        x(ix) = x(ix) + t*dx;	%Rescale from steps to x.
        %disp(['x',num2str(ix),' midl:',num2str(x(ix)),' d0=',num2str(d0),',d1=',num2str(d1),',d2=',num2str(d2)]);
        y = ParaY(x,y);		%Adjust y for the special new x-position, that is probably near the centre.
        yy = y;			%Carry the working position along, in case of the next ix iteration.
      end			%Hopefully, not too close to provoke small difference problems.
    end			%Enough fiddling with that x.
    [xd,err,r] = ParaDiddle(3,x,y);		%Show for each x-fiddle.
    %pic = pic + 1; Movie(pic) = getframe;
   end				%Move to another x-variable.

   if all(straddle(2:N))	%Was eveyone close?
    dx = dx/2;			%Tighten the screws. Perhaps too slowly.
    %disp(['try ',int2str(tries),',dx = ',num2str(dx)]);	%Slow progress?
   end;				%Too small a step provokes bad evaluations.
   %disp(['pass',num2str(pass),': y(1)=',num2str(y(1)),',y(2)=',num2str(y(2))]);
   %ParaDiddle(3,x,y);	%The state with all x-values adjusted, and y-values have been optimised for them.
  %keyboard
  
  
  %Generate LaTeX typesetting code to typeset up loss curve (DJH)
  
  end				%Have another go.
  
 end				%If a go was worth having.
 
 disp(['Final x= ',num2str(x)]); disp(['Final y= ',num2str(y)]);
 disp(['x - x0 = ',num2str(x - x0)]); disp(['y - y0 = ',num2str(y - y0)]);
 en = Paraquat(x,y);		%The final merit.
 disp(['Started with ',num2str(e0),', ended with ',num2str(en),', diff ',num2str(e0 - en),', e0/en=',num2str(e0/en),', try count = ',int2str(tries)]);
 merit(N) = en;			%Stash them in sequence with N.
 



disp(['Err(i)/Err(i-1) = ',num2str(merit(2:N)./merit(1:N - 1))]);
clear ix1 ix2 ix iy t xx yy zz d0 d1 d2 dx nG straddle;
%keyboard
pd=0;
eval(['latex_fig(x,y,X,Y,xd,err,hstep,hg,''default_' num2str(N) '.tex'',''Y'',r)']);


end;			%On to the next N.
