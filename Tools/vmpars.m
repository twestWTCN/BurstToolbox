function [R2,s,stdeqv] = vmpars(X,Y)
% will fit von-mises dist to loop of Y
for i = 1:size(Y,2)
%             figure(4)
    [dum dum R2(i) s(:,i) stdeqv(i)] = vmfit(X,Y(:,i)',50,0);
%     hold on
%             close all
end
