% ------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------
% This file is written to realize the algorithm-Online learning projection
% matrix and sparsify dicitonary learning simultaneously.
%
% Input:
%       param: a struct which contains the necessary parameters.
%       param.X: contains the training data
%       param.X_test: contains the testing data
%       param.epsilon: the precision of the algorithm for evaluating some
%                      trivial values. In order to avoide the numerical error, we utilize
%                      epsilon to replace 0. The default is 1e-6.
%
%       param.L: the number of columns of the designed dictionary.
%       param.M: the number of rows of the sensing matrix.
%       param.K: the number of non-zero of the sparsity coefficients.
%       param.Iter: the number iteration. It can be omitted if we utilize the number of updating
%                    projection matrix and dictionary as the termination.
%       param.Batchsize: the number of Batch size. The default is 64;
%
%       % the mode used in the paper
%       param.mode_A: utilize mode_A to update the matrix A_t and B_t.
%                      e.g., A_t = (1-1/t)^rho*A_{t-1}++\alpha*\alpha'; where t is the number of
%                      iteration. If this is true, the parameter rho should
%                      be defined. The default is true.
%       param.rho: the parameter for mode_A, the default is 15.
%       ---------------------------------------------------------------------
%
%       param.mode_B: utilize mode_B to update the matrix A_t and B_t.
%                     A_t = beta*A_{t-1}+\alpha*\alpha'; where beta =
%                     \frac{\theta+1-Batchsize}{\theta+1} with \theta = t*Batchsize if
%                     t<Batchsize and Batchsize^2+t-Batchsize if t>=Batchsize.
%                     Note that either mode_A or mode_B can be true.mode_A
%                     has highest priority.
%
%       param.mode_C: if it is true, it means data information older than
%       two epoches is not contained in A_t and B_t. This can be true 
%       together with mode_A or mode_B. The default is true.
%
%       param.gamma: the trade-off parameter between sparse representation error (SRE) and
%                    projected SRE.
%
%       param.Iter_dic: In practice, 1 is enough.
%                       It means we updating the columns of D only 1 round.
%                       The default is 1.
%
%       param.Iter_update_D: the number of updating dictionary.
%                            Note that, every time, the different training date is utilized.
%                            The default is 1000.
%       param.Phi_update_times: the number of updating sensing
%                               matrix. The default is 10.
%
%       param.Percent: the percent of unused atoms compared to the maximal
%                      used atoms. The default is 0.5%.
%       param.Iter_unused: after this iteration, we go to check whether to
%                          replace the unused atoms to the training data.
%                          The default is 1000.
%        param.Initial; whether give the initial value, the default is false. If this is true, 
%                       the DCT dictionary and random matrix are given as
%                       the initial value; Otherwise, we random choose the
%                       training data as the dictionary and then optimize
%                       the corresponding sensing matrix as initial value.
%
%       param.Convergence_Check: if it is true, we will go to evaluate the
%                         PSNR, objective value and the difference of dictionary
%                         during iteration. The default is false. Note that if it is true,
%                         the algorithm will become slow because we have to evaluate some
%                         measures. Moreover, a relative large iterations will be given in
%                         the last dictionary iteration. The default is 15000 and can be set
%                         through the param.Max_Last_iter. Notice that the testing data
%                          should be given if we want to work on this
%                          mode.
% Output:
%       Phi_array: the finial array of sensing matrix.
%       Psi_array: the trained sparsifying dictionary in array.
%       CPUtime: a vector which contains the traintime.
%       test_error_array: a vector which contains the test error versus
%                         traintime.
%       PSNR_array and dif_dic_array.
% Author: Tao Hong CS-Faculty-Technion 27th Apr. 2018.
% @Copyright.
% ------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------