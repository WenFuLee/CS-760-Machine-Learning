%% initialize a matrix A 
clear all;
load('./mlinstancetag.csv')
ita = 0.015 % learning rate
y = mlinstancetag
A_ini = randn(33,9)
%% update each ite
threshold = 0.25
% for the outer iteration 
for j=1:30 
    for t = 1:705
        yi = y(t,:)'
        Ainv = pinv(A_ini)
        zt = Ainv*yi
        newzt = zeros(9,1)
        for k=1:9
            if(zt(k) > threshold^(2/j+1))
                newzt(k) = zt(k)
            else
                newzt(k) = 0
            end
        end
        % update 
        At = A_ini + ita *(yi - A_ini * newzt)*newzt'
    end
    A_ini = At
end

fprintf('Feature Matrix'); A_ini
A_feature = []
for i = 1:9
    ai = max(0,A_ini(:,i))
    A_feature = [A_feature ai]
end
X = A_feature \ y'
index = zeros(705,1)
for i=1:705
    index(i) = (find(X(:,i) == max(X(:,i))))
end
index = []
for i = 1:9 
    [val ind] = sort(A_feature(:,i),'descend')
    index = [index ind]
end

    
    
    
