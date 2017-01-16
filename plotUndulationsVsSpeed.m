%% plot undulation amplitude vs speed from single worm data

close all
clear

for strain = {'npr-1','CB4856','N2'}
    % find all files in the directory tree
    files = rdir(['../wormtracking/eigenworms/singleWorm/' strain{:} '/**/*.mat']);
    numWorms = size(files,1);
    
    % prealloc cell arrays to store wormwise data
    amplitudes = cell(numWorms,1);
    speeds = cell(numWorms,1);
    
    for wormCtr = 1:numWorms
        % load single worm data - somehow the filenames can have funny
        % characters in them from rdir which we need to remove
        load(strrep(files(wormCtr).name,'._',''))
        
        speeds{wormCtr} = worm.locomotion.velocity.midbody.speed;
        amplitudes{wormCtr} = worm.locomotion.bends.midbody.amplitude;
    end
    
    %% plot
    histogram2(horzcat(speeds{:}),horzcat(amplitudes{:}),'DisplayStyle','tile',...
        'Normalization','probability','EdgeColor','none')
    xlabel('midbody speed')
    ylabel('midbody bend amplitude')
    title(strain{:},'FontWeight','normal')
    xlim([-700 700])
    ylim([-60 60])
    %% export figure
    exportOptions = struct('Format','eps2',...
        'Color','rgb',...
        'Width',14,...
        'Resolution',300,...
        'FontMode','fixed',...
        'FontSize',10,...
        'LineWidth',2);
    set(gcf,'PaperUnits','centimeters')
    filename = ['parameterisationPlots/undulationsVspeed' strain{:}];
    exportfig(gcf,[filename '.eps'],exportOptions);
    system(['epstopdf ' filename '.eps']);
    system(['rm ' filename '.eps']);
end