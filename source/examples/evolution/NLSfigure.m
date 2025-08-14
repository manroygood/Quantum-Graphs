NLSOnBalancedStarSDIRK443;
eD=energyDiff;
maD = massDiff;
moD = momentumDiff;
u1=u;
NLSOnUnbalancedStarSDIRK443

figure(12);tiledlayout(2,3,'TileSpacing','tight','Padding','tight');
nexttile
G.plot(abs(u0));
zlabel('$\left|\psi\right|_{t=0}$','fontsize',22)

nexttile
G.plot(abs(u1(:,end)));
myz=get(gca,'zlim');dar=get(gca,'DataAspectRatio');
zlabel('$\left|\psi\right|_{t=15}$','fontsize',22)

nexttile
G.plot(abs(u(:,end)),'reddish');
set(gca,'zlim',myz,'DataAspectRatio',dar)
zlabel('$\left|\psi\right|_{t=15}$','fontsize',22)

nexttile(4)
plot(t,maD,t,massDiff,'--')
xlabel('$t$')
ylabel('$\frac{\left| E(t)-E(0) \right|}{\left| E(0) \right|}$')

nexttile(5)
plot(t,eD,t,energyDiff,'--')
xlabel('$t$')
ylabel('$\frac{\left| E(t)-E(0) \right|}{\left| E(0) \right|}$')

nexttile(6)
plot(t,moD,t,momentumDiff,'--')
xlabel('$t$')
ylabel('$\frac{\left| p(t)-p(0) \right|}{\left| E(0) \right|}$')



for k=1:6
    nexttile(k);
    set(gca,'fontsize',22)
end