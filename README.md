MLSP 2014 Schizophrenia Classification Challenge: <br />Winning Model Documentation
==

[Arno Solin](http://becs.aalto.fi/~asolin/) (Doctoral student at Aalto University, instructor Dr. [Simo Särkkä](http://www.lce.hut.fi/~ssarkka/))


Summary
--
The goal of the [competition](http://www.kaggle.com/c/mlsp-2014-mri) was to automatically diagnose subjects with schizophrenia based on multimodal features derived from their magnetic resonance imaging (MRI) brain scans. The winning proposition was based on a Gaussian process (GP) classifier, where the observations are considered to be drawn from a Bernoulli distribution. The probability is related to the latent function via a sigmoid function that transforms it to a unit interval. A GP prior with a covariance function as a sum of a constant, linear, and Matérn kernel was placed over the latent functions. The model was trained by sampling using the [GPstuff toolbox](http://becs.aalto.fi/en/research/bayes/gpstuff/).

For more details, see the [model documentation report](http://becs.aalto.fi/~asolin/).


Dependencies
--
This solution builds heavily upon the [GPstuff toolbox](http://becs.aalto.fi/en/research/bayes/gpstuff/) for Mathworks **Matlab** (or Octave). It is our in-house-developed software package for Gaussian process modeling. All codes were tested in Matlab 8.2.0.701 (R2013b), and GPstuff version 4.5 (release 2014-07-22, available online, and distributed under the GNU General Public License) in Ubuntu Linux.


Code description
--
All files are written in Mathworks Matlab, and running the scripts require installation of the \gpstuff\ toolbox. The following files are provided:

* `settings.m` (Matlab)
  1. Specifies the path to the training data (`TRAIN_DATA_PATH`), test data (`TEST_DATA_PATH`), model (`MODEL_PATH`), and submission output directories (`SUBMISSION_PATH`). This is the only place that specifies the paths to these directories.
  2. The GPstuff toolbox is added to the Matlab path with appropriate initializations.
* `train.m` (Matlab)
  1. Read training data from `TRAIN_DATA_PATH` (specified in `settings.m`).
  2. Do the normalization steps.
  3. Set up and train the GP classifier (Note that the random number generator seed is not specified).
  4. Save the model under `MODEL_PATH` (specified in `settings.m`).
* `predict.m` (Matlab)
  1. Read the training and test data from `TRAIN_DATA_PATH` and `TEST_DATA_PATH`, and do the normalization steps.
  2. Load the model from `MODEL_PATH`.
  3. Use the model to make predictions on new samples.
  4. Save the predictions to `SUBMISSION_PATH`.


How to generate the solution
--

The following steps should be taken to replicate the model training procedure (in order to use the exactly same samples, load the serialized model from disk by only running the prediction in `predict.m`):

* Download and unpack the [GPstuff toolbox](http://becs.aalto.fi/en/research/bayes/gpstuff/). Additional speedup can be gained by mexing (see the toolbox documentation, or just run `matlab_install.m`).
* Modify (to set the paths) and run `setup.m` in Matlab.
* Run `train.m` in Matlab to train the GP classifier (note that the random seed is not fixed). The model is saved under the path specified in `setup.m`.
* Run `predict.m` in Matlab to predict using the GP classifier. The model output is stored under the path specified in `setup.m`.

The winning model (serialized and saved) and submission CSV file are stored under `./model/` and `./submission/`, respectively.


License
--

This software is distributed under the GNU General Public License (version 3 or later); please refer to the file `LICENSE.txt`, included with the software, for details. 

