% test woid model for different strain parameterisations
% to do:

clear

N = 40;
M = 49;
L = [7.5, 7.5];
dT = 0.035/0.33/16; % baseline timestep, eg rc/v0/8 when bending
saveEvery = 32;
T = 400;
addpath('visualisation')

% xyarray = runWoids(T,N,M,L,'bc','noflux','dT',dT,'saveEvery',saveEvery,...
%     'theta_0',pi*37/180);
% save('results/DA609_noflux')
% animateWoidTrajectories(xyarray,'tests/DA609_noflux',L);
% 
% xyarray = runWoids(T,N,M,L,'bc','noflux','dT',dT,'saveEvery',saveEvery,...
%     'theta_0',pi*37/180,'slowingNodes',1:M);
% save('results/DA609_noflux_slowingNodesAll')
% animateWoidTrajectories(xyarray,'tests/DA609_noflux_slowingNodesAll',L);

eps_LJ = 4e-4;
xyarray = runWoids(T,39,M,L,'bc','periodic','dT',dT,'saveEvery',saveEvery,...
    'theta_0',pi*37/180,'r_LJcutoff',5*0.035,'eps_LJ',eps_LJ,'sigma_LJ',2*0.035);
save(['results/DA609_noflux_lennardjones' num2str(eps_LJ,'%1.0e')])
animateWoidTrajectories(xyarray,['tests/DA609_periodic_lennardjones' num2str(eps_LJ,'%1.0e')],L);

% xyarray = runWoids(T,N,M,L,'bc','noflux','dT',dT,'saveEvery',saveEvery,...
%     'v0',0.14,...
%     'omega_m',2*pi*0.26,...
%     'theta_0',pi*37/180,...
%     'revRate',1/11,...
%     'revTime',1.5,...
%     'revRateCluster',1/11,...
%     'headNodes',[],...
%     'tailNodes',[]);
% save('results/N2_noflux')
% animateWoidTrajectories(xyarray,'tests/N2_noflux',L);
