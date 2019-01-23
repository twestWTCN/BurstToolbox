function BB = computeBetaBurstPLVStats(R,BB)
for cond = 1:length(R.condname)
    for band = 3; %2:size(R.bandef,1)
        % Segment PLV during Bursts
        if isequal([band cond],[3 1])
            BB.segPLV = {nan(1,size(R.bandef,1),2) nan(1,size(R.bandef,1),2)};
            BB.segRP  = {nan(size(R.bandef,1),2) nan(size(R.bandef,1),2)};
            BB.segRP = {nan(1) nan(1)};
            BB.segPLV  = {nan(1) nan(1)};
        end
        for ci = 1:size(BB.segA_save{cond},2)
            tind = BB.segTInds{cond}{ci};
            dind  = BB.segInds{cond}{ci};
            swind = find(BB.SWTvec{cond} >= tind(1) & BB.SWTvec{cond} < tind(2));
            %             BB.segPLV{cond}(:,band,ci) = mean(BB.PLV{cond}(band,swind));
            %             BB.segRP{cond}(band,ci) = circ_mean(BB.RP{cond}(band,swind),[],2);
            if ~any(isnan(dind))
                X = remnan(BB.RPdtime{cond}(dind));
                BB.segRP{cond}(band,ci) = circ_mean(X,[],1);
                %             BB.segPLV{cond}(:,band,ci) = bootstrapPLV(X,BB.period);
                BB.segPLV{cond}(:,band,ci) = computePPC(BB.PhiTime{cond}(:,dind));
                
            end
        end
       
        % Normalize the PPC
        if numel(BB.segPLV{cond})>2
            BB.segPLV{cond}(:,band,:) = (BB.segPLV{cond}(:,band,:)-median(BB.segPLV{cond}(:,band,:),3))./median(BB.segPLV{cond}(:,band,:),3)*100;
        end
        
%         close all
        % Bin data by PLV and find Amplitude
        BB.binPLVEd = BB.range.PLV;
        if isequal([band cond],[3 1]); BB.Amp_binPLV = []; end
        for bs = 1:numel(BB.binPLVEd)-1
            if size(BB.segA_save{cond}(:),1)>1
                s = find(BB.segPLV{cond}(:,band,:)>=BB.binPLVEd(bs) & BB.segPLV{cond}(:,band,:)<BB.binPLVEd(bs+1));
            else
                s = 1;
            end
            % Unnormalized
            x = nanmean(BB.segA_save{cond}(s));
            xv = nanstd(BB.segA_save{cond}(s))/sqrt(numel(s));
            w = (numel(s)/numel(BB.segAPrc_save{cond}));
            %             if numel(s)<2; w = 0; end
            
            BB.Amp_binPLV(bs,band,cond,1) = x*w;
            BB.Amp_binPLV(bs,band,cond,2) = xv*w;
            BB.Amp_binPLV_data{cond}{bs} = BB.segA_save{cond}(s);
            
            % Percentage Deviation
            x = nanmean(BB.segAPrc_save{cond}(s));
            xv = nanstd(BB.segAPrc_save{cond}(s))/sqrt(numel(s));
            w = (numel(s)/numel(BB.segAPrc_save{cond}));
            %             if numel(s)<2; w = 0; end
            
            BB.AmpPrc_binPLV(bs,band,cond,1) = x*w;
            BB.AmpPrc_binPLV(bs,band,cond,2) = xv*w;
            BB.AmpPrc_binPLV_data{cond}{bs} = BB.segAPrc_save{cond}(s);
        end
        

    end
end


%% script grave
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
