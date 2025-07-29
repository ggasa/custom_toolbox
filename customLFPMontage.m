function customLFPMontage(data, params)
%Dan Kim 2025.07.22

%{
% Auto-handle JSON string or filename input
if ischar(file) || isstring(file)
    if exist(file, 'file')
        jsonText = fileread(file);
    else
        jsonText = dataOrFilename;  % Assume raw JSON string
    end
    data = jsondecode(jsonText);
elseif isstruct(dataOrFilename)
    data = dataOrFilename;
else
    error('Unsupported input format. Must be struct, JSON string, or JSON filename.');
end
%} 


%Two data formats co-exist (structure or cell of structures)
nRecordings = size(data.LFPMontage, 1);
if ~iscell(data.LFPMontage)
    S = cell(nRecordings, 1);
    for recId = 1:nRecordings
        S{recId} = data.LFPMontage(recId);
    end
    data.LFPMontage = S;
end

%Extract LFP montage data
LFPMontage.LFPFrequency = data.LFPMontage{1}.LFPFrequency;
LFPMontage.LFPMagnitude = NaN(size(LFPMontage.LFPFrequency, 1), nRecordings);
for recId = 1:nRecordings
    LFPMontage.hemisphere{recId} = afterPoint(data.LFPMontage{recId}.Hemisphere);
        %!Dan's added code
    %Naming change to numbers from words...
    LFPMontage.channel_names{recId} = strrep(strrep(strrep(strrep(strrep(afterPoint(data.LFPMontage{recId}.SensingElectrodes), 'ZERO', '0'), ...
    'ONE', '1'), ...
    'TWO', '2'), ...
    'THREE', '3'), ...
    '_', ' ');
    LFPMontage.LFPMagnitude(:, recId) = data.LFPMontage{recId}.LFPMagnitude;
    LFPMontage.ArtifactStatus{recId} = afterPoint(data.LFPMontage{recId}.ArtifactStatus); 
end

%define savename
recNames = data.LfpMontageTimeDomain(1).FirstPacketDateTime;
savename = regexprep(char(recNames), {':', '-'}, {''});

%Changing the savename for plot titles and saving.
date = [savename(1:end-5)];
savename = [params.subjectID ' ' date ' ' params.recordingMode];

%plot LFP Montage
LFPMontage.hemisphere = categorical(LFPMontage.hemisphere);
hemisphereNames = unique(LFPMontage.hemisphere);
nHemispheres = numel(hemisphereNames);
channelsFig = figure;

for hemisphereId = 1:nHemispheres
    subplot(nHemispheres, 1, hemisphereId)
    hold on
    legend_label = {};

    for i = 1:nRecordings
        is_hem = LFPMontage.hemisphere(i) == hemisphereNames(hemisphereId);
        is_space_ok = count(LFPMontage.channel_names{i},' ') < 3;
        if is_hem && is_space_ok
            %change the LFPmagnitude to dB
            LFPMag = LFPMontage.LFPMagnitude(:,i); %in uVp, select only the ones that correspond to the target hemisphere
            dbLFPMag = 20*log10(LFPMag);
            %plot
            plot(LFPMontage.LFPFrequency, dbLFPMag);
            %store labels
            legend_label{end+1} = LFPMontage.channel_names{i};
        else
            %disp('----PSD: Inter and Intra ring channel signals skipped----')
            continue
        end
    end
    
    xlabel('Frequency (Hz)');
    ylabel('PSD (dB(from mV))');
    title(['LFP Montage ' char(hemisphereNames(hemisphereId))])
    leg = legend(legend_label);
    set(leg,'Fontsize',8)
end

sgtitle([savename ' | LFP Magnitude'])
set(channelsFig, 'Units', 'inches');
set(channelsFig, 'Position', [1, 1, 8, 6]);
savefig(channelsFig, [params.save_pathname filesep savename '_LFPMontage']);
save


%Save as .png
exportgraphics(channelsFig, fullfile(params.save_pathname, [savename '_LFPMontage.png']), 'Resolution', 500);


%save data
save([params.save_pathname filesep savename '.mat'], 'LFPMontage')