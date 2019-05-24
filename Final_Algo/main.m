% function demo
% 
close all; clear all;clc
%load data.mat;
load mlinstancetag_v2.csv

k=9;
[pz pdz pwz pzdw]=plsa(mlinstancetag_v2',k);  
whos pz; whos pdz; whos pwz;

% imagesc(pz); colormap(gray); colorbar; 
% title('Probability of topics pz'); 
% xlabel('topic z_i'); ylabel('probability');
% 
% figure;
% imagesc(pdz); colormap(gray); colorbar;
% title('Category probability of document pdz'); 
% xlabel('document d_i (pdz_{(i,j)} is the prob. that d_i belongs to z_j)'); ylabel('topic z_j');
% 
% figure;
% imagesc(pwz); colormap(gray); colorbar;
% title('Category probability of word pwz'); 
% xlabel('word w_i (pwz_{(i,j)} is the prob. that w_i belongs to z_j)'); ylabel('topic z_j');

[m n]=size(mlinstancetag_v2')  
pzd = zeros(k, n);
whos pzd
for i = 1:n
    pzd(:, i) = pz' .* pdz(:, i); 
end

for i = 1:n
    deno(i) = sum(pzd(:, i)); 
end

for i = 1:n
    for j = 1:k
        pzd(j, i) = pzd(j, i) / deno(i); 
    end
end

%% Return max index of topic
[Y,I] = max(pzd);

%% Sort indexes of key words
[B,I] = sort(pwz, 2, 'descend')
