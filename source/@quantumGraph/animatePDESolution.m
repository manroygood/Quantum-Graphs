function animatePDESolution(G,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

tString=toGreek(inputname(3));
realFlag=isreal(U);
nEdges=G.numedges;
nt=length(t);

if G.has3DLayout
    for n=1:nt
        hold off
        if realFlag
            Ut=U(:,n);
        else
            Ut=abs(U(:,n)).^2;
        end
        for k=1:nEdges
            G.column2graph(Ut);
            [y,x1,x2,x3]=G.fullEdge(k);
            colorplot3(x1,x2,x3,y);
            hold on
        end
        title(sprintf('$%s=%0.2f$',tString,t(n)))
        view([-70 40])
        axis equal off
        colorbar
        drawnow
    end
else
    myBlue = mcolor('blue'); % The default MATLAB line color
    myGray = mcolor('silver');
    l=cell(nEdges,1);
    clf;
    plot3(nan,nan,nan);
    hold on;
    G.column2graph(abs(U(:,1)).^2);
    for k=1:nEdges
        [~,x1,x2]=G.fullEdge(k);
        ww=G.weight(k)*2;
        plot3(x1,x2,zeros(size(x1)),'color',myGray,'linewidth',ww);
        l{k} = plot3(nan,nan,nan);
        l{k}.XData = [];
        l{k}.YData = [];
        l{k}.ZData = [];
        l{k}.Color = myBlue;
        l{k}.LineWidth = ww;
    end
    
    [x1Range,x2Range]=plotRange(G);
    xRange = min(x1Range,x2Range);
    if realFlag
        zMin=min(min(U));
        zMax=max(max(U));
    else
        zMin=0;
        zMax=max(max(abs(U).^2));
    end
    zRange=zMax-zMin;
    
    set(gca,'DataAspectRatio',[xRange xRange 1.25*zRange])
    set(gca,'ZLim',[zMin,1.1*zMax])
    
    for n=1:nt
        if realFlag
            Ut=U(:,n);
        else
            Ut=abs(U(:,n)).^2;
        end
        for k=1:nEdges
            G.column2graph(Ut);
            [y,x1,x2]=G.fullEdge(k);
            l{k}.XData=x1;
            l{k}.YData=x2;
            l{k}.ZData=y;
        end
        title(sprintf('$%s=%0.1f$',tString,t(n)))
        drawnow
    end
end

hold off