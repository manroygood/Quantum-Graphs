function pcolorPDESolution(U,Phi,t)%xmax,tRight)


n=Phi.numedges;
U=abs(U).^2;
[~,nxC]= Phi.nx;
bottomU=min(U(:));topU=max(U(:));

% plot the first edge
k=1;
subplot(n,1,k)

xFirst=nxC(k)+1;xLast=nxC(k+1,:);
UU=U(xFirst:xLast,:);
pcolor(t,-Phi.x{k},UU);shading interp;colormap(parula)

%if exist('xmax','var'); set(gca,'ylim',[-xmax 0]); end
%if exist('tfinal','var');set(gca,'xlim',[0 tfinal]);end
caxis manual; caxis([bottomU topU]); % Adjust the color axis to be shared among all subplots
box on
ylabel('$x_1$');
set(gca,'linewidth',2)

% plot the remaining edge
for k=2:n
    subplot(n,1,k)
    UU=U(nxC(k)+1:nxC(k+1,:),:);
    pcolor(t,Phi.x{k},UU);shading interp;colormap(parula)
    
%    if exist('xmax','var'); set(gca,'ylim',[0 xmax]); end
%    if exist('tRight','var'); set(gca,'xlim',[0 tRight]);end
    caxis manual; caxis([bottomU topU]); % Adjust the color axis to be shared among all subplots
    box on
    ylabel(sprintf('$x_%i$',k));
    set(gca,'linewidth',2)
end
xlabel('$t$')
colorbar('location','Manual', 'position', [0.93 0.1 0.02 0.81]);
