%% Time Evolution for DAE Check - Gracie Conte
%
%% Solves the heat/Schrodinger equation on the line graph
close all
G = quantumGraph(1,2,pi,'nxVec',32,'RobinCoeff',[0,0]);
xgrid = pi*chebptsSecondKind(30);
u0 = cos(xgrid);
tend = 1;

[u,t] = timeEvolveDAEDopri8(G,u0,1e-4,tend);
uheat = @(x,t) cos(x)*exp(-t);
uschr = @(x,t) cos(x)*exp(-1i*t);
error = zeros(1,size(u,2));

scale = 100;

for i=1:size(u,2)/scale
    plot(xgrid,u(:,scale*i))
%     plot(xgrid,abs(u(:,scale*i)).^2)
    axis([0 pi -2 2])
    title(['t=',num2str(t(scale*i))])
    xlabel('x')
    ylabel('u')
    error(scale*i) = norm(uheat(xgrid',t(scale*i)) - u(:,scale*i));
    pause(.0000000001)
end

max(error)




%% Solves the heat/Schrodinger equation on the dumbbell graph
close all

LVec = [2*pi,4,2*pi];
n = 32; nX=[n n n];
robinCoeff = [0 0];
Phi = quantumGraph([1 1 2],[1 2 2],LVec,'nxVec',nX,'RobinCoeff',robinCoeff);

xgrid = chebptsSecondKind(30);
tend = 1;

u1=@(x)  sin(x);
u2=@(x) -cos(pi*x/2) + 1;
uheat1=@(x,t)  sin(x)*exp(-t);
uheat2=@(x,t) (-cos(pi*x/2)+1)*exp(-pi^2*t/4);
uschr1=@(x,t)  sin(x)*exp(-1i*t);
uschr2=@(x,t) (-cos(pi*x/2)+1)*exp(-1i*pi^2*t/4);

u1grid = u1(2*pi*xgrid);
u2grid = u2(4*xgrid);
u0 = [u1grid u2grid u1grid];

[u,t] = timeEvolveDAE(Phi,u0',1e-05,tend);
error = zeros(1,size(u,2));

plotCoordsCheb = dumbellPlotCoordsCheb(Phi);
Phi.addPlotCoords(plotCoordsCheb);

scale = 10000;
for i=1:size(u,2)/scale
    Phi.plot(u(:,scale*i))
    hold on
    Phi.plot(transpose([uheat1(2*pi*xgrid,t(scale*i)) uheat2(4*xgrid,t(scale*i)) uheat1(2*pi*xgrid,t(scale*i))]))
    title(['t=',num2str(t(scale*i))])
    axis([-4 4 -1.5 1.5 -2 2])
    daspect([1 1 1])
    xlabel('x')
    ylabel('y')
    zlabel('u')
    error(scale*i) = norm(transpose([uheat1(2*pi*xgrid,t(scale*i)) uheat2(4*xgrid,t(scale*i)) uheat1(2*pi*xgrid,t(scale*i))]) - u(:,scale*i));
    pause(.0000000001)
end

max(error)

max(error)



%% Plotting the solution
plotCoordsCheb = dumbellPlotCoordsCheb(G);
G.addPlotCoords(plotCoordsCheb);

% % fignum = 1;
% for i = 1:50 % (tend/stepsize+1)
% %     figure(fignum)
%     G.plot(u(i,:))
%     title(['t=',num2str(t(i))])
%     axis([-4 4 -1.5 1.5 -2 2])
%     daspect([1 1 1])
%     xlabel('x')
%     ylabel('y')
%     zlabel('u')
%     t = t + stepsize;
%     pause(.01)
%     
% %     filename = 'timeEvlLinear.gif';
% %       del = 0.01; % time between animation frames
% %       drawnow 
% %       frame = getframe(fignum);
% %       im = frame2im(frame);
% %       [imind,cm] = rgb2ind(im,256);
% %       if i == 1
% %         imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',del);
% %       else
% %         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',del);
% %       end
% end
