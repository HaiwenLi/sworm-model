% plot woidlet phase portrait
% shows plots of correlation analysis
close all
clear

exportOptions = struct('Format','eps2',...
    'Color','rgb',...
    'Width',17,...
    'Resolution',300,...
    'FontMode','fixed',...
    'FontSize',6,...
    'LineWidth',1,...
    'Renderer','opengl');

radius = 0.035;
plotColor = [0.25, 0.25, 0.25];
Nval = 80;
Lval = 10.6;
revRatesClusterEdge = [0, 0.1, 0.2, 0.4, 0.8];
speeds = [0.33];
slowspeeds = fliplr([0.33, 0.1, 0.05, 0.025]);
% slowspeeds = fliplr([0.33, 0.2, 0.1, 0.05]);
attractionStrength = [0];
trackedNodes = 1:5;
distBinwidth = 0.035; % in units of mm, sensibly to be chosen similar worm width or radius
% define functions for grpstats
mad1 = @(x) mad(x,1); % median absolute deviation
% alternatively could use boxplot-style confidence intervals on the mean,
% which are 1.57*iqr/sqrt(n)
for speed = speeds
    poscorrFig = figure;
    speedFig = figure;
    dircorrFig = figure;
    velcorrFig = figure;
    plotCtr = 1;
    poscorrFig.Name = ['v_0 = ' num2str(speed)];
    speedFig.Name = ['v_0 = ' num2str(speed)];
    for slowspeed = slowspeeds
        for revRateClusterEdge = revRatesClusterEdge
            filename = ['../results/woids/woids' '_N_' num2str(Nval) '_L_' num2str(Lval) ...%'_noUndulations'...
                '_v0_' num2str(speed,'%1.0e') ...
                '_vs_' num2str(slowspeed,'%1.0e') '_gradualSlowDown' ...
                '_epsLJ_' num2str(attractionStrength,'%1.0e') ...
                '_revRateClusterEdge_' num2str(revRateClusterEdge,'%1.0e') '.mat'];
            if exist(filename,'file')
                thisFile = load(filename);
                maxNumFrames = size(thisFile.xyarray,4);
                burnIn = round(0.1*maxNumFrames);
                numFrames =  min(round((maxNumFrames - burnIn)*thisFile.param.dT*thisFile.saveevery),maxNumFrames - burnIn); %maxNumFrames-burnIn;
                %             framesAnalyzed = burnIn + randperm(maxNumFrames - burnIn,numFrames); % randomly sample frames without replacement
                framesAnalyzed = round(linspace(burnIn,maxNumFrames,numFrames));
                %             framesAnalyzed = burnIn+1:maxNumFrames;
                %% calculate stats
                [s_med,s_ci, corr_o_med,corr_o_ci, corr_v_med,corr_v_ci, gr,distBins] = ...
                    correlationanalysisSimulations(thisFile,trackedNodes,distBinwidth,framesAnalyzed);
                %% plot data
                % radial distribution / pair correlation
                set(0,'CurrentFigure',poscorrFig)
                subplot(length(slowspeeds),length(revRatesClusterEdge),plotCtr)
                boundedline(distBins(2:end)-distBinwidth/2,mean(gr,2),...
                    [nanstd(gr,0,2) nanstd(gr,0,2)]./sqrt(numFrames))
                ax = formatAxes(revRateClusterEdge,slowspeed);
                ax.YTick = 0:4;
                ax.YLim = [0 4];
                % speed v distance
                set(0,'CurrentFigure',speedFig)
                bins = (0:numel(s_med)-1).*distBinwidth;
                subplot(length(slowspeeds),length(revRatesClusterEdge),plotCtr)
                boundedline(bins,s_med,[s_med - s_ci(:,1), s_ci(:,2) - s_med])
                ax = formatAxes(revRateClusterEdge,slowspeed);
                ax.YLim = [0 0.5];
                ax.YTick = 0:0.1:0.5;
                ax.XDir = 'reverse';
                % directional and velocity cross-correlation
                bins = (0:numel(corr_o_med)-1).*distBinwidth;
                set(0,'CurrentFigure',dircorrFig)
                subplot(length(slowspeeds),length(revRatesClusterEdge),plotCtr)
                boundedline(bins,corr_o_med,[corr_o_med - corr_o_ci(:,1),...
                    corr_o_ci(:,2) - corr_o_med])
                ax = formatAxes(revRateClusterEdge,slowspeed);
                ax.YLim = [-1 1];
                ax.YTick = [-1 0 1];
                set(0,'CurrentFigure',velcorrFig)
                subplot(length(slowspeeds),length(revRatesClusterEdge),plotCtr)
                boundedline(bins,corr_v_med,[corr_v_med - corr_v_ci(:,1),...
                    corr_v_ci(:,2) - corr_v_med])
                ax = formatAxes(revRateClusterEdge,slowspeed);
                ax.YLim = [-1 1];
                ax.YTick = [-1 0 1];
            end
            plotCtr = plotCtr + 1;
        end
    end
    %% export figures
    % radial distribution / pair correlation
    poscorrFig.PaperUnits = 'centimeters';
    filename = ['figures/woidPhasePortraitRadialdistribution_N_' num2str(thisFile.N) '_L_' num2str(thisFile.L(1)) ...%'_noUndulations'...
        '_speed_'...
        num2str(speed,'%1.0e') '_slowing' '_gradual'...
        '.eps'];
    exportfig(poscorrFig,filename, exportOptions)
    system(['epstopdf ' filename]);
    system(['rm ' filename]);
    % speed v distance
    speedFig.PaperUnits = 'centimeters';
    filename = ['figures/woidPhasePortraitSpeedvDistance_N_' num2str(thisFile.N) '_L_' num2str(thisFile.L(1)) ...%'_noUndulations'...
        '_speed_' num2str(speed,'%1.0e') '_slowing' '_gradual'...
        '.eps'];
    exportfig(speedFig,filename, exportOptions)
    system(['epstopdf ' filename]);
    system(['rm ' filename]);
    % directional and velocity cross-correlation
    dircorrFig.PaperUnits = 'centimeters';
    filename = ['figures/woidPhasePortraitDirxcorr_N_' num2str(thisFile.N) '_L_' num2str(thisFile.L(1)) ...%'_noUndulations'...
        '_speed_' num2str(speed,'%1.0e') '_slowing' '_gradual'...
        '.eps'];
    exportfig(dircorrFig,filename, exportOptions)
    system(['epstopdf ' filename]);
    system(['rm ' filename]);
    velcorrFig.PaperUnits = 'centimeters';
    filename = ['figures/woidPhasePortraitVelxcorr_N_' num2str(thisFile.N) '_L_' num2str(thisFile.L(1)) ...%'_noUndulations'...
        '_speed_' num2str(speed,'%1.0e') '_slowing' '_gradual'...
        '.eps'];
    exportfig(velcorrFig,filename, exportOptions)
    system(['epstopdf ' filename]);
    system(['rm ' filename]);
end

function ax = formatAxes(revRateClusterEdge,slowspeed)
title(['r=' num2str(revRateClusterEdge) ', v_s =' num2str(slowspeed,'%1.0e')],...
    'FontWeight','normal')
ax = gca;
ax.Position = ax.Position.*[1 1 1.2 1.2] - [0.0 0.0 0 0]; % stretch panel
ax.XLim = [0 2];
ax.XTick = 0:2;
ax.XTickLabel = [];
ax.YTickLabel = [];
ax.Box = 'on';
grid on
end