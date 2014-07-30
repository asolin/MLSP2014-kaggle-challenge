%%
% TRAIN.m
%
% Author:
%   Arno Solin, 2014
%
% License:
%   This software is distributed under the GNU General Public License 
%   (version 3 or later); please refer to the file LICENSE.txt, included 
%   with the software, for details. 
%

%%
% Load data (the TRAIN_DATA_PATH is specified in 'settings.m')
%

  % Load labels
  labels_train = dataset('file', ...
    fullfile(TRAIN_DATA_PATH,'train_labels.csv'),'Delimiter',',');

  % Load training FNC features from file into a dataset array variable
  FNC_train = dataset('file', ...
    fullfile(TRAIN_DATA_PATH,'train_FNC.csv'),'Delimiter',',');

  % Load training SBM features from file into a dataset array variable
  SBM_train = dataset('file', ...
    fullfile(TRAIN_DATA_PATH,'train_SBM.csv'),'Delimiter',',');


%%
% Combine and normalize data
%

  % Convert to y \in {-1,1}, 
  % where Healthy Control => -1 and Schizophrenic Patient => 1
  y = 2*double(labels_train.Class)-1;

  % Normalize feature vectors by their standard deviations
  x = [bsxfun(@rdivide,double(SBM_train(:,2:end)), ...
         std(double(SBM_train(:,2:end)),[],1)) ...
       bsxfun(@rdivide,double(FNC_train(:,2:end)), ...
         std(double(FNC_train(:,2:end)),[],1))];


%%
% Train GP classifier
%
    
  % Create likelihood function
  lik = lik_probit();

  % Set GP prior covariance structure
  gpcf1 = gpcf_linear();
  gpcf2 = gpcf_constant();
  gpcf3 = gpcf_matern52('lengthScale',.01);
  gpcf  = gpcf_sum('cf',{gpcf1,gpcf2,gpcf3});
  
  % Create the GP structure
  gp = gp_set('lik', lik, 'cf', gpcf, 'jitterSigma2', 1e-9);
  
  % Optimizer parameters for the Laplace approximation
  opt = optimset('TolFun',1e-3,'TolX',1e-3,'Display','iter');
  
  % Use the Laplace approximation for initialization
  gp = gp_set(gp, 'latent_method', 'Laplace');
  gp = gp_optim(gp,x,y,'opt',opt);
  
  % Continue by MCMC
  gp = gp_set(gp, 'latent_method', 'MCMC', 'jitterSigma2', 1e-6);
  [gp_rec] = gp_mc(gp, x, y, 'nsamples', 1000, 'display', 20);
  
  % Remove burn-in and thin
  gp = thin(gp_rec,100,10);

    
%%
% Save model 
%
  
  % Write model to disk (MODEL_PATH specified in 'settings.m')
  save(MODEL_PATH,'gp');

