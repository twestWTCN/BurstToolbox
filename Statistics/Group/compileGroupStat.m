function BBG = compileGroupStat(R,BB,BBG,side,sub,lflag,cflag)
if cflag == 0 % compiling step
    for cond = 1:numel(R.condname)
        if lflag == 0
            BBG.segAmpGroup{cond,side,sub} = BB.segAmp{cond};
            BBG.segAmpPrcGroup{cond,side,sub} = BB.segAmpPrc{cond};
            BBG.segDurGroup{cond,side,sub} = BB.segDur{cond};
            BBG.segPLVGroup{cond,side,sub} = squeeze(BB.segPLV{cond})';
            BBG.recLGroup{cond,side,sub} = diff(BB.Tvec{cond}([1 end]))/60;
            BBG.Amp_binRPGroup{cond,side,sub} = squeeze(BB.Amp_binRP(:,1,cond));
            BBG.AmpPrc_binRPGroup{cond,side,sub} = squeeze(BB.AmpPrc_binRP(:,1,cond));
            BBG.PLV_binRPGroup{cond,side,sub} = squeeze(BB.PLV_binRP(:,1,cond));
            BBG.AmpPrc_binPLVGroup{cond,side,sub} = squeeze(BB.AmpPrc_binPLV(:,1,cond));
            
            % Binned Amp by Dur
            BBG.Dur_binAmpGroup{cond,side,sub} = squeeze(BB.Dur_binAmp(:,1,cond));
            BBG.Amp_binDurGroup{cond,side,sub} = squeeze(BB.Amp_binDur(:,1,cond));
            
            % bs,band,cond,1
            if numel(BB.segAmp{cond})>2
                stvec = statvec(BB.segAmp{cond}',BB.segDur{cond}',2);
                BBG.regstatsGroup(:,:,side,sub) =stvec; %[stind cond side sub]
            else
                BBG.regstatsGroup(:,:,side,sub) =nan(1,5); %[stind cond side sub]
            end
            % correlations
            BBG.ampDurSpearman{cond,side,sub} = BB.corrs.ampdur.spearman{cond};
            BBG.ampDurRegress{cond,side,sub} = BB.corrs.ampdur.rest_regress{cond};
        elseif lflag == 1
            BBG.segAmpGroup{cond,side,sub} = [];
            BBG.segDurGroup{cond,side,sub} = [];
            BBG.segPLVGroup{cond,side,sub} = [];
            BBG.recLGroup(cond,side,sub) = 0;
            BBG.Amp_binRPGroup(:,cond,side,sub) = NaN(size(squeeze(BB.Amp_binRP(:,1,cond))));
            BBG.AmpPrc_binRPGroup(:,cond,side,sub) = NaN(size(squeeze(BB.AmpPrc_binRP(:,1,cond))));
            BBG.PLV_binRPGroup(:,cond,side,sub) = NaN(size(squeeze(BB.PLV_binRP(:,1,cond))));
            BBG.Dur_binAmpGroup(:,cond,side,sub) = NaN(size(squeeze(BB.Dur_binAmp(:,1,cond))));
        end
    end
elseif cflag == 1 % post hoc compiling (BB is now BBG)
    % Resizes so that the side dimension is squeezed out (for cell formatted variables)
    BBG.recLGroup = reshape(BBG.recLGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.recLGroupF{cond} = sum([BBG.recLGroup{cond,:}]); end
    %
    BBG.segAmpGroup = reshape(BBG.segAmpGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.segAmpGroupF{cond} = [BBG.segAmpGroup{cond,:}]; end
    
    BBG.segAmpPrcGroup = reshape(BBG.segAmpPrcGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.segAmpPrcGroupF{cond} = [BBG.segAmpPrcGroup{cond,:}]; end
    
    BBG.segDurGroup = reshape(BBG.segDurGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.segDurGroupF{cond} = [BBG.segDurGroup{cond,:}]; end
    
    BBG.segPLVGroup = reshape(BBG.segPLVGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.segPLVGroupF{cond} = vertcat(BBG.segPLVGroup{cond,:})'; end
    
    BBG.Amp_binRPGroup = reshape(BBG.Amp_binRPGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.Amp_binRPGroupF{cond} = [BBG.Amp_binRPGroup{cond,:}]; end
    
    BBG.AmpPrc_binRPGroup = reshape(BBG.AmpPrc_binRPGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.AmpPrc_binRPGroupF{cond} = [BBG.AmpPrc_binRPGroup{cond,:}]; end
    
    BBG.PLV_binRPGroup = reshape(BBG.PLV_binRPGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.PLV_binRPGroupF{cond} = [BBG.PLV_binRPGroup{cond,:}]; end
    
    BBG.AmpPrc_binPLVGroup = reshape(BBG.AmpPrc_binPLVGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.AmpPrc_binPLVGroupF{cond} = [BBG.AmpPrc_binPLVGroup{cond,:}]; end
    
    BBG.Dur_binAmpGroup = reshape(BBG.Dur_binAmpGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.Dur_binAmpGroupF{cond} = [BBG.Dur_binAmpGroup{cond,:}]; end
    
    BBG.Amp_binDurGroup = reshape(BBG.Amp_binDurGroup,3,[]);
    for cond = 1:numel(R.condname); BBG.Amp_binDurGroupF{cond} = [BBG.Amp_binDurGroup{cond,:}]; end
    
    BBG.ampDurSpearman = reshape(BBG.ampDurSpearman,3,[]);
    for cond = 1:numel(R.condname); BBG.ampDurSpearmanF{cond} = [BBG.ampDurSpearman{cond,:}]; end
    
    BBG.ampDurRegress = reshape(BBG.ampDurRegress,3,[]);
    for cond = 1:numel(R.condname); BBG.ampDurRegressF{cond} = [BBG.ampDurRegress{cond,:}]; end
end