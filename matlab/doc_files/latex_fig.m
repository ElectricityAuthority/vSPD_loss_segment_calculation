function [] = latex_fig(x,y,X,Y,xd,err,hstep,hg,tikzpgfname,errorYN,r);

opacity = 0.75;
linewidth = 0.75;

disp(r)

if r>5;
    err=err/(r/5);
end

hgp = [hstep' hg];
hgp2 = [[0,0] ; hgp];
hgp3 = [hgp2 ; [1,0]];
hgp4 = [hgp3 ; [0,0]];

%create some temp disk files with X^2, error and probability data
%keyboard

%open/create a latex file in text write mode to include in latex code with \include

fid = fopen(tikzpgfname,'wt');

btp1 = ['\begin{tikzpicture}[xscale=7.0,yscale=7.0]'];
grid1 = ['\draw [help lines,step=0.1] (0,0) grid (1,1);'];
fprintf(fid,'%s\n',char(btp1));
fprintf(fid,'%s\n',char(grid1));

%Draw histogram in backgroung
hgYN = 0;
keyboard
if hgYN == 0;
    eval(['dlmwrite(''' tikzpgfname(1:end-4) '_XY.dat'',[X''  Y''],''delimiter'','' '',''precision'',''%2.8f'')']);
    eval(['dlmwrite(''' tikzpgfname(1:end-4) '_err.dat'',[xd''  err''+0.5],''delimiter'','' '',''precision'',''%2.8f'')']);
end

if hgYN == 1;
    eval(['dlmwrite(''' tikzpgfname(1:end-4) '_XY.dat'',[X''  Y''],''delimiter'','' '',''precision'',''%2.8f'')']);
    eval(['dlmwrite(''' tikzpgfname(1:end-4) '_hg.dat'',hgp4,''delimiter'','' '',''precision'',''%2.8f'')']);
    eval(['dlmwrite(''' tikzpgfname(1:end-4) '_err.dat'',[hstep''  err''+0.5],''delimiter'','' '',''precision'',''%2.8f'')']);
    hg_dist1 = ['\filldraw[line width=0.5pt,color=blue!25!white,draw opacity=0.15,fill opacity = 0.5] plot file {' tikzpgfname(1:end-4) '_hg.dat};'];   fprintf(fid,'%s\n',char(hg_dist1));
end    
    


%Draw the X^2 curve
xsqd = ['\draw[line width=0.5pt,color=black] plot file {' tikzpgfname(1:end-4) '_XY.dat};'];   fprintf(fid,'%s\n',char(xsqd));

%Draw co-ordanate at (1,1)
oo = ['\coordinate (oneone) at (1,1);'];
fprintf(fid,'%s\n',char(oo));
oo2 = ['\filldraw [red,draw opacity=' num2str(opacity) '] (oneone) circle (0.1pt);'];
fprintf(fid,'%s\n',char(oo2));

%Now loop through and print coordinate positions
for n=1:length(x); %ignore first point
    c1 = ['\coordinate (bk' num2str(n) ') at (' num2str(x(n)) ',' num2str(y(n)) ');'];
    fprintf(fid,'%s\n',char(c1));
end

for n=2:length(x)-1; %ignore first point
    %Now draw circle at coordinate positions (except first and last, (0,0) and (1,1)
    c2 = ['\filldraw [red,draw opacity=' num2str(opacity) '] (bk' num2str(n) ') circle (0.1pt) node[right] {\tiny \texttt{(' num2str(x(n),4) ',' num2str(y(n),4) ')}};'];
    fprintf(fid,'%s\n',char(c2));
end

for n=1:length(x)-1;  %Draw each line segment
  line_seg = ['\draw[line width=' num2str(linewidth) 'pt,color=red,draw opacity=' num2str(opacity) '] (bk' num2str(n) ') -- (bk' num2str(n+1) '); '];
  fprintf(fid,'%s\n',char(line_seg));
end

% 
therest1 = ['\draw[->] (0,0) -- node[midway,yshift=-0.75cm] {\footnotesize flow} (1,0);']; fprintf(fid,'%s\n',char(therest1));
therest2 = ['\draw[->] (0,0) -- node[rotate=90,midway,yshift=0.75cm] {\footnotesize loss} (0,1) ;']; fprintf(fid,'%s\n',char(therest2));
therest3 = ['\foreach \x/\xtext in {0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}'];
fprintf(fid,'%s\n',char(therest3));
therest4 = ['\draw (\x cm,0pt) -- (\x cm,-0.5pt) node[anchor=north] {\footnotesize \xtext};'];
fprintf(fid,'%s\n',char(therest4));
therest5 = ['\foreach \y/\ytext in {0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}'];
fprintf(fid,'%s\n',char(therest5));
therest6 = ['\draw (0.0pt,\y cm) -- (-0.25pt,\y cm) node[anchor=east,xshift=0.5mm] {\footnotesize \ytext};'];
fprintf(fid,'%s\n',char(therest6));

%Now plot the error, if wanted

if errorYN == 'Y';
   %Draw the error
   r=5;
   errd = ['\draw[line width=0.5pt,color=green,draw opacity=' num2str(opacity) '] plot file {' tikzpgfname(1:end-4) '_err.dat};'];   fprintf(fid,'%s\n',char(errd));
   theresterr1 = ['\foreach \y/\ytext in {0/-' num2str(0.5/r) ',0.1/-' num2str(0.4/r) ',0.2/-' num2str(0.3/r) ',0.3/-' num2str(0.2/r) ',0.4/-' num2str(0.1/r) ',0.5/0.0,0.6/' num2str(0.1/r) ',0.7/' num2str(0.2/r) ',0.8/' num2str(0.3/r) ',0.9/' num2str(0.4/r) ',1.0/' num2str(0.5/r) '}'];
   fprintf(fid,'%s\n',char(theresterr1));
   theresterr2 = ['\draw (1cm,\y cm) -- (1.01cm,\y cm) node[anchor=west,xshift=-0.75mm] {\tiny \textcolor{green}{\ytext}};'];
   fprintf(fid,'%s\n',char(theresterr2));
   if hgYN == 0;
      theresterr3 = ['\node[rotate=90] at (1.1,0.5) {\footnotesize \textcolor{green}{error}};'];
      fprintf(fid,'%s\n',char(theresterr3));
   end
   if hgYN == 1;
      theresterr3 = ['\node[rotate=90] at (1.1,0.5) {\footnotesize \textcolor{green}{weighted error}};'];
      fprintf(fid,'%s\n',char(theresterr3));
   
   
   end
end

endtext = ['\end{tikzpicture}'];
fprintf(fid,'%s\n',char(endtext));

fclose(fid)
% 
% 





