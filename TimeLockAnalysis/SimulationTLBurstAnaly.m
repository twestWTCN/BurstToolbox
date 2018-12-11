function SimulationTLBurstAnaly(R,BB,xsimMod,AS)
addpath(R.BBA_path)

PLVcmp = 0;
close all
F(1) = figure; F(2) = figure; F(3) = figure; F(4) = figure;
BurstTimeLockAnalysis(R,1,BB,0,F);
figure(F(1)); title('Full Model');figure(F(2)); title('Full Model');figure(F(3)); title('Full Model');figure(F(4)); title('Full Model')

BurstTimeLockAnalysis(R,2,BB,0,F);
figure(F(1)); title('No Hyperdirect'); figure(F(2)); title('No Hyperdirect'); figure(F(3)); title('No Hyperdirect'); figure(F(4)); title('No Hyperdirect')
% 
BurstTimeLockAnalysis(R,3,BB,0,F);
figure(F(1)); title('No Cortico-Striatal');figure(F(2)); title('No Cortico-Striatal');figure(F(3)); title('No Cortico-Striatal');figure(F(4)); title('No Cortico-Striatal')

set(F(1),'Position',[374.0000  258.5000  894.5000  620.0000])
set(F(2),'Position',[374.0000  88.0000   894.5000  224.0000])
set(F(3),'Position',[374.0000  88.0000   894.5000  224.0000])
set(F(4),'Position',[374.0000  88.0000   894.5000  224.0000])