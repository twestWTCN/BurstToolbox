function [R2,s,stdeqv] = vmpars(X,Y)

for i = 1:size(Y,2)
%             figure(4)
    [dum,dum,R2(i),s(:,i),stdeqv(i)] = VMfit(X,Y(:,i)',50,0);
%     hold on
%             close all
end