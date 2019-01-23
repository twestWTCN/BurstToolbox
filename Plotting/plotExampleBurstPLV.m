function plotExampleBurstPLV(R,BB)
    BB.T = linspace(0,length([BB.A{1:2}])/BB.fsamp,length([BB.A{1:2}])); % Data time
    BB.TSw = linspace(0,length([BB.PLV{1:2}])/BB.fsamp_sw,length([BB.PLV{1:2}])); % sliding window time



set(gcf,'defaultAxesColorOrder',[[0 0 0]; [0.2 0.2 0.6]]);
for cond = 1:2
    mInd = R.BB.pairInd(2);
    % Amplitude
    subplot(3,2,sub2ind([2 3],cond,1))
    yyaxis left
    a(1) = plot(BB.DTvec{cond},BB.A{cond}(mInd,:)); hold on
    a(1).Color = R.condcmap(cond,:); ylim([0 200])
    a(3) = plot(BB.DTvec{cond}([1 length(BB.A{cond}(mInd,:))]),[BB.epsAmp(mInd) BB.epsAmp(mInd)],'--');
    a(3).Color = [0 0 0];
    a(3).LineWidth = 1;
    ylabel([R.bandinits{2} ' Amplitude'])
    xlabel('Time (s)');
    title('Wavelet Amplitude')
    box off
    % Phase
    subplot(3,2,sub2ind([2 3],cond,2))
    yyaxis right
% %     a(1) = plot(BB.TSw([1:length(BB.PLV{cond}(1,:))]),BB.PLV{cond}(1,:)); hold on
    a(1) = plot(BB.DTvec{cond}(2:end),diff(BB.RPdtime{cond})'); hold on
    a(1).Color = R.condcmap(cond,:);
% %     ylim([0 1])
    ylabel([R.bandinits{2} ' PPC'])
    xlabel('Time (s)');
    title('Wavelet Pairwise Phase Consistency')
    box off
    % Amplitude/Phase Zoomed
    subplot(3,2,sub2ind([2 3],cond,3))
    yyaxis right
% %     a(1) = plot(BB.T([1:length(BB.PLV{cond}(1,:))]),BB.PLV{cond}(1,:)); hold on
    a(1) = plot(BB.DTvec{cond}(2:end),diff(BB.RPdtime{cond})'); hold on
    a(1).Color = R.condcmap(cond,:);
    a(1).LineStyle = ':';
    a(1).LineWidth = 1.5;
% %     ylim([0 1])
    ylabel([R.bandinits{2} ' PPC'])
    
    yyaxis left
    a(2) = plot(BB.DTvec{cond}([1:length(BB.A{cond}(mInd,:))]),BB.A{cond}(mInd,:)); hold on
    a(2).Color = R.condcmap(cond,:);
    a(2).LineWidth = 1.5;
    a(3) = plot(BB.DTvec{cond}([1 length(BB.A{cond}(mInd,:))]),[BB.epsAmp(mInd) BB.epsAmp(mInd)],'--');
    a(3).Color = [0 0 0];
    a(3).LineWidth = 1;
    ylabel([R.bandinits{2} ' Amplitude'])
    xlabel('Time (s)');
    title('Both (zoomed)')
    box off
    xlim([50 60])
    
end