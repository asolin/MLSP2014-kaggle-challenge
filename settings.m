%%
% SETTINGS.m
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
% Set paths
%

  TRAIN_DATA_PATH = './train/';
  TEST_DATA_PATH  = './test/';
  MODEL_PATH      = './model/gp.mat';
  SUBMISSION_PATH = './submission/submission.csv';


%%
% Add path to the GPstuff toolbox
%

  % Set the GPstuff path
  addpath('/path/to/GPstuff/');

  % Run GPstuff startup script
  startup;

