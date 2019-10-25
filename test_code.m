clear; clc;
close all;

addpath('narmaxutils');

%% Generate test data
N = 300;
e = 0.1*randn(N,1);
y = zeros(N,1);
u = 2*rand(N,1) - 1;

y(2) = -0.605*y(1) + 0.588*u(1) + e(2);
for k = 3:N
    y(k) = -0.605*y(k-1) - 0.163*y(k-2)^2 + 0.588*u(k-1) - 0.240*u(k-2) - 0.4*e(k-1) + e(k);
end

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

%% Make some plots
t = 1:N;
% Ys_mean = mean(Ys,2);
plot(t,y,t,Ys);

%% Display model equation
displayEquation(nmodel);