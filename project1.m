clear; clc;
close all;

addpath('narmaxutils');

%% Generate test data from model
% N = 300;
% e = 0.1*randn(N,1);
% y = zeros(N,1);
% u = 2*rand(N,1) - 1;

% y(2) = -0.605*y(1) + 0.588*u(1) + e(2);
% for k = 3:N
%     y(k) = -0.605*y(k-1) - 0.163*y(k-2)^2 + 0.588*u(k-1) - 0.240*u(k-2) - 0.4*e(k-1) + e(k);
% end

%% read data
m = readtable('sample.csv','ReadVariableNames',true,'Delimiter',',');

%convert text to serial date number directly
%notice that the input format is different from datetime() !!!
%subtract a "preset" number from all entries
preset = datenum(m.TIMESTAMP(1),'yyyy/mm/dd HH:MM');
m.time = datenum(m.TIMESTAMP,'yyyy/mm/dd HH:MM') - preset;

y = m.WS_10m_Avg;
%y = normalize(m.WS_10m_Avg);
N = size(y,1);
u = ones(N,1);

% %first, let's try to fit into a sum of sines model
% f = fit(m.time, m.WS_10m_Avg, 'sin1');
% hold on 
% plot(m.time,m.WS_10m_Avg)
% plot(f)
% hold off

%% Create narmax model
nmodel = narmax(y, u);

%% Configure and invoke frols algorithm passing NARMAX model
ny = 2;
nu = 0;
ne = 2;
nl = 2;
nterms = [4 1];
iter = 500;

[nmodel, estInds, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iter);

%% Generate a simulation file under name modeltest for fast simulation
generatesimfunc(nmodel, 'modeltest', 1);

%% Call the just generated simulation function
Ys = modeltest(u, 0, 0);

%% Make some plots
t = 1:N;
% Ys_mean = mean(Ys,2);
plot(t,y,t,Ys);
