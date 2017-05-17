function ax = plotWoidTrajectoriesSingleFrame(xyarray,L,rc,plotColors)
% takes in an array of N by M by x y  by T and makes a movie of the resulting
% trajectories

% issues/to-do:

% short-hand for indexing coordinates
x =     1;
y =     2;

if nargin <3
    rc = 0.035;
    disp(['Setting node radius to ' num2str(rc) ' for animations.'])
end

N = size(xyarray,1);
M = size(xyarray,2);
if nargin < 4
    plotColors = lines(N);
elseif size(plotColors,1)==1
    plotColors = repmat(plotColors,N,1);
end
assert(size(plotColors,1)==N,'Number of colors not matching number of objects')
angles = linspace(0,2*pi,10)'; % for plotting node size

% set overall axes limits
xrange = minmax(reshape(xyarray(:,:,x,:),1,numel(xyarray(:,:,x,:))));
yrange = minmax(reshape(xyarray(:,:,y,:),1,numel(xyarray(:,:,y,:))));
xrange = [floor(xrange(1)) ceil(xrange(2))];
yrange = [floor(yrange(1)) ceil(yrange(2))];

if M>1% plot connecting lines btw nodes
    % don't plot connecting lines for objects that span across a
    % periodic boundary
    excludedObjects = any(any(abs(diff(xyarray,1,2))>min(L./2),3),2);
    plot(xyarray(~excludedObjects,:,x)',xyarray(~excludedObjects,:,y)','-',...
        'Marker','.','Color','k');
else
    plot(xyarray(:,:,x)',xyarray(:,:,y)','.','Color','k');
end
hold on

ax = gca;
% plot circular domain boundaries, if given scalar domain size
if nargin>=3&&numel(L)==1
    viscircles(ax,[0 0],L,'Color',[0.5 0.5 0.5],'LineWidth',2,'EnhanceVisibility',false);
    ax.XLim = [-L L];
    ax.YLim = [-L L];
else
    ax.XLim = xrange;
    ax.YLim = yrange;
end
ax.DataAspectRatio = [1 1 1];
ax.XTick = [];
ax.YTick = [];
for objCtr = 1:N
    patch(xyarray(objCtr,:,x) + rc*cos(angles),...
        xyarray(objCtr,:,y) + rc*sin(angles),...
        plotColors(objCtr,:),'EdgeColor',plotColors(objCtr,:))
    % patches seems to be faster than viscircles
    %         viscircles(squeeze(xyarray(objCtr,:,[x y],frameCtr)),rc*ones(M,1),...
    %             'Color',plotColors(objCtr,:),'EnhanceVisibility',false,...
    %             'LineWidth',1);
end

end