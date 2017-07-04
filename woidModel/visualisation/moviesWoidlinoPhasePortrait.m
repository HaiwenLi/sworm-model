% make movies from simulation results...

clear
close all

% general model parameters for all test - unless set otherwise
L = [7.5, 7.5]; % L: size of region containing initial positions - scalar will give circle of radius L, [Lx Ly] will give rectangular domain
% rc = 0.035;
N = 40;
M = 18;
revRatesClusterEdge = fliplr([0, 0.1, 0.2, 0.4, 0.8]);
speeds = [0.33];
slowspeeds = fliplr([0.33, 0.1, 0.05, 0.025]);
attractionStrengths = [0];
paramCombis = combvec(revRatesClusterEdge,speeds,slowspeeds,attractionStrengths);
nParamCombis = size(paramCombis,2);
for paramCtr = 1:nParamCombis % can be parfor but might impair movie quality
    revRateClusterEdge = paramCombis(1,paramCtr);
    speed = paramCombis(2,paramCtr);
    slowspeed = paramCombis(3,paramCtr);
    attractionStrength = paramCombis(4,paramCtr);
    filename = ['wlM' num2str(M) '_N_' num2str(N) '_L_' num2str(L(1)) ...
                    '_v0_' num2str(speed,'%1.0e') '_vs_' num2str(slowspeed,'%1.0e') ...
                    '_gradualSlowDown' ...
                    '_epsLJ_' num2str(attractionStrength,'%1.0e') ...
                    '_revRateClusterEdge_' num2str(revRateClusterEdge,'%1.0e')];
    if exist(['../results/woidlinos/' filename '.mat'],'file')...
            &&~exist(['../movies/woidlinos/' filename '.mp4'],'file')
        out = load(['../results/woidlinos/' filename '.mat']);
        animateWoidTrajectories(out.xyarray,['../movies/woidlinos/' filename],L,out.param.rc);
    elseif ~exist(['../results/woidlinos/' filename '.mat'],'file')
        disp(['no results for ' filename])
    end
end