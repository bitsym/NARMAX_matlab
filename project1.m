clear; clc;
close all;

addpath('narmaxutils');

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
nu = 1;
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
