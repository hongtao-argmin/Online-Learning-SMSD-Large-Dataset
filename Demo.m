% ---------------------------------------------------------------------------
clear;
clc;
close all;

% --------------------------------------------------------------------------------
load('****.mat') % load your training data and name it as X.
[N,n] = size(X);
load('***.mat') % load your testing data and name it as X_test
rng(5,'v5uniform')
% train the sensing matrix and sparsifying for the following three
% methods
% parameter seting
%%
Phi_update_times = 10; 
L = 256;
M = 20;
K = 4;
Batchsize = 128;
Iter_update_D = 1e3;

param = struct('X',X,'X_test',X_test,'epsilon',1e-6,'L',L,'M',M,'K',K,'mode_A',true,...
    'gamma',1/32,'Iter_dic',1,'Iter_update_D',Iter_update_D,'Phi_update_times',Phi_update_times,...
    'Percent',0.005,'Iter_unused',1000,'Batchsize',Batchsize,'Initial',false,'Convergence_Check',false);

[Phi_array_alg3,Psi_array_alg3,CPUtime_alg3,test_error_array,PSNR_array,dif_dic_array] = Online_Sens_DIC_simultaneously(param);
