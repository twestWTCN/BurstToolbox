function BB = computeBetaBurstPLVStats(R,BB)
% This function compiles the statistics for the synchronization measures
% and does binning of the amplitude by sync index

BB.segPLV = {nan(1,size(R.bandef,1),2) nan(1,size(R.bandef,1),2)};
BB.segRP  = {nan(size(R.bandef,1),2) nan(size(R.bandef,1),2)};
BB.segRP = {nan(1) nan(1)};
BB.segPLV  = {nan(1) nan(1)};
BB.Amp_binPLV = [];
for cond = 1:length(R.condname)
    % Compute the relative phase/sync index within the burst
    for ci = 1:size(BB.segAmp{cond},2)
        dind  = BB.segInds{cond}{ci};
        if ~any(isnan(dind))
            X = remnan(BB.RP{cond}(dind));
            BB.segRP{cond}(ci) = circ_mean(X,[],1); % THIS IS A PROBLEM
            switch R.BB.PLmeth
                case 'PLV'
                    BB.segPLV{cond}(:,ci) = abs(mean(exp(-1i*X),1));
                case 'PPC'
                    BB.segPLV{cond}(:,ci) = computePPC(BB.Phi{cond}(:,dind));
            end
        end
    end
    
    % %     % Normalize the sync metric (OPTIONAL!)
    % %     if numel(BB.segPLV{cond})>2
    % %         BB.segPLV{cond}(:,band,:) = (BB.segPLV{cond}(:,band,:)-median(BB.segPLV{cond}(:,band,:),3))./median(BB.segPLV{cond}(:,band,:),3)*100;
    % %     end
    
    % Bin amplitude by PLV
    [BB.Amp_binPLV(:,:,cond),BB.Amp_binPLV_data{cond}] = binDatabyRange(BB.segPLV{cond},BB.range.PLV,BB.segAmp{cond});
    % Bin normalized amplitude by PLV
    [BB.AmpPrc_binPLV(:,:,cond),BB.AmpPrc_binPLV_data{cond}] = binDatabyRange(BB.segPLV{cond},BB.range.PLV,BB.segAmpPrc{cond});
end

BB.guide = [BB.guide;{...
    'segPLV - burst sync index'
    'segRP - burst relative phase'
    'Amp_binPLV - burst amplitude by PLV'
    'Amp_binPLV_data - "" data'
    'AmpPrc_binPLV - burst prc amps bin by PLV'
    'AmpPrc_binPLV_data - "" data'
    }];




%% %%%%%%%%%%%%%%%%%%%
%%% script grave %%%%%%
% %  COMPUTE NON-SEGMENTED SCATTERGRAMS
% % figure; p = 0;
% % for cond = 1:2
% %     for band = 2:3
% %         p = p+1;
% %         tarC = 1:10:length(BB.SWTvec{cond});
% %         A = BB.SWTvec{cond}(tarC);           % Slow Time
% %         B = BB.DTvec{cond}(1:end); % Fast Time
% %
% %         % Resample the Fast time relative to Slow
% %         C = [];
% %         for ac = 1:length(A); [c index] = min(abs(A(ac)-B)); C(ac) = index; end
% %         AmpResamp = BB.A{cond}(2,C); % Low beta amp
% %         PLVResamp = BB.PLV{cond}(band,tarC); % variable b1/2 PLV
% %         subplot(2,2,p)
% %         s = scatter(AmpResamp,PLVResamp,25,R.condcmap(cond,:),'filled');
% %         s.MarkerFaceAlpha = 0.75;
% %     end
% % end

% % function PLVBS = bootstrapPLV(X,period)
% % np = floor(size(X,1)/floor(period));
% % npInd = randperm(size(X,1));
% % npInd = reshape(npInd(1:np*floor(period)),np,floor(period));
% % for i = 1:np
% %     PLVBS(i)= abs(mean(exp(-1i*X(npInd(i,:))),1));
% % end
% % PLVBS = mean(PLVBS);

% %         % PS-DFA
% %         X = unwrap(BB.RP{cond}(3,:));
% %         X = diff(X);
% %         X = remnan(X')';
% %         DFAP = [];
% %         DFAP(1) = BB.fsamp; DFAP(2) = 8/14;  DFAP(3) = 8;  DFAP(4) = 50;  DFAP(5) = 0;
% %         [bmod win evi alpha] = peb_dfa_gen(X,DFAP,0);
% %         BB.PSDFA(:,cond) = [alpha evi(2)];
