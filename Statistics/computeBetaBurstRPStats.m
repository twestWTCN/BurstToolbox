function BB = computeBetaBurstRPStats(R,BB)
% This function computes relative phase
BB.Seg_binRP = []; BB.PLV_binRP = [];
for cond = 1:length(R.condname)
    if ~isfield(BB,'segRP') % if doesnt exist compute relative phase
        for ci = 1:size(BB.segAmp{cond},2)
            dind  = BB.segInds{cond}{ci};
            if ~any(isnan(dind))
                X = remnan(BB.RP{cond}(dind));
                BB.segRP{cond}(ci) = circ_mean(X,[],1); % THIS IS A PROBLEM
            end
        end
    end
    
    % Bin amplitude by RP
    [BB.Amp_binRP(:,:,cond),BB.Amp_binRP_data{cond}] = binDatabyRange(BB.segRP{cond},BB.range.RP,BB.segAmp{cond});
    % Bin normalized amplitude by RP
    [BB.AmpPrc_binRP(:,:,cond),BB.AmpPrc_binRP_data{cond}] = binDatabyRange(BB.segRP{cond},BB.range.RP,BB.segAmpPrc{cond});
    % Bin sync index by RP
    [BB.PLV_binRP(:,:,cond),BB.PLV_binRP_data{cond}] = binDatabyRange(BB.segRP{cond},BB.range.RP,BB.segPLV{cond});
    
end
BB.guide = [BB.guide;{...
    'Amp_binRP - burst amplitude by RP'
    'Amp_binRP_data - "" data'
    'AmpPrc_binRP - burst Amp bin by RP'
    'AmpPrc_binRP_data - "" data'
    'PLV_binRP - sync index bin by RP'
    'PLV_binRP_data - "" data'
    }];

