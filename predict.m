%%
% PREDICT.m
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
% Load data 
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

  % Load test FNC features from file into a dataset array variable
  FNC_test = dataset('file', ...
    fullfile(TEST_DATA_PATH,'test_FNC.csv'),'Delimiter',',');

  % Load test SBM features from file into a dataset array variable
  SBM_test = dataset('file', ...
    fullfile(TEST_DATA_PATH,'test_SBM.csv'),'Delimiter',',');


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

  % Normalize test set feature vectors in the same way
  xt = [bsxfun(@rdivide,double(SBM_test(:,2:end)), ...
          std(double(SBM_train(:,2:end)),[],1)) ...
        bsxfun(@rdivide,double(FNC_test(:,2:end)), ...
          std(double(FNC_train(:,2:end)),[],1))];    
  

%%
% Load the trained model
%

  % Load the model 'gp' (MODEL_PATH specified in 'settings.m')
  load(MODEL_PATH);

  
%%
% Predict test inputs
%

  % Predict
  [Eft, Varft, lpyt] = gp_pred(gp, x, y, xt, 'yt', ones(size(xt,1),1));
  
  % The label probabilities
  tpreds = exp(lpyt);


%%
% Save the result
%

  % Load example submission from file into a dataset array variable
  example = dataset('file','submission_example.csv','Delimiter',',');

  % Enter your scores into the example dataset
  example.Probability = tpreds(:);

  % Save your scores in a new submission file. The SUBMISSION_PATH 
  % is specified in 'settings.m'. This assumes you have write permission 
  % to the specified folder.
  export(example,'file',SUBMISSION_PATH,'Delimiter',',');

