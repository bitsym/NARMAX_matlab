clear; clc;
close all;

addpath('narmaxutils');

%% read data
m = readtable('sample.csv','ReadVariableNames',true,'Delimiter',',');

% % convert text to serial date number directly
% % subtract a "preset" number from all entries
preset = datenum(m.TIMESTAMP(1),'yyyy/mm/dd HH:MM');
m.time = datenum(m.TIMESTAMP,'yyyy/mm/dd HH:MM') - preset + 1;

y = normalize(m.WS_10m_Avg);
u = m.time;
N = size(y,1);

%% Create narmax model
nmodel = narmax(y, u);

%% Configure and invoke frols algorithm passing NARMAX model
ny = 2;
nu = 2;
ne = 2;
nl = 2;
nterms = [4 1];
iter = 500;

[nmodel, estInds, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iter);

%% Generate a simulation file under name modeltest for fast simulation
generatesimfunc(nmodel, 'modeltest', 1);

%% Call the just generated simulation function
Ys = modeltest(u, 0, 0);

%% run for 20 times
% Ys = zeros(N,20);
% 
% for k = 1:20
%     
% % Create narmax model
% nmodel = narmax(y, u);
% 
% % Configure and invoke frols algorithm passing NARMAX model
% ny = 2;
% nu = 2;
% ne = 2;
% nl = 2;
% nterms = [4 1];
% iter = 500;
% 
% [nmodel, estInds, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iter);
% 
% % Generate a simulation file under name modeltest for fast simulation
% generatesimfunc(nmodel, 'modeltest', 1);
% 
% % Call the just generated simulation function
% Ys(:,k) = modeltest(u, 0, 0);
% end

%% Make some plots
t = 1:N;
% Ys_mean = mean(Ys,2);
plot(t,y,t,Ys);
