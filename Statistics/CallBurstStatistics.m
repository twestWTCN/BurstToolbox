function BB = CallBurstStatistics(R,BB)
if ~isfield(BB,'range')
    % Setup Bin Ranges
    BB.range.Amp = linspace(-2,-0.5,20);% 1:0.25:5; %0:5:120; % Group: 0:3:120; single: 0:5:80
    BB.range.segDur = linspace(1.5,3.2,24); %0:100:1800; % Group: 0:100:1800; single: 25:150:1800
    BB.range.AmpPrc = 0:5:100;
    BB.range.AmpPrc = 0:5:100;
end
% Setup Plot Limits
if ~isfield(BB.plot,'lims')
    BB.plot.lims.burfreq = [0 6; 0 15];
    BB.plot.lims.PLV = [-100 100]; %[0 0.35];
    BB.plot.lims.PLVun = [0 0.6];
    BB.plot.lims.wPLV = [-10 10];
    BB.plot.lims.Amp =  [-2 -0.5];
    BB.plot.lims.wAmpPrc =  [-2 6];
    BB.plot.lims.Dur = [1.8 3.2];
end
% Compute  Burst Amplitude/Duration Statistics
% for i = 1:5; F(i) = figure; end
BB = computeBetaBurstAmpDurStats_v2(R,BB);

