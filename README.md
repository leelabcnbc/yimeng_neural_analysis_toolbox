yimeng_neural_analysis_toolbox
==============================


## Introduction
A package for analzying (now mainly for importing) neural data (now NEV), mostly written in MATLAB.

## Motivation

The existing analysis tools (used by Jason and Corentin) are not flexible or well-structured. The biggest problem is that, **code change** is necessary for each different experiment. To import data for an new experiment, a considerable amount of code has to be modified. When importing data of old experiments, the code has to be modified again, all over different files. This makes our data import **extremely difficult to reproducible and debug**. Therefore, based on existing code, I want to make a better package for importing neural data. I hope that this code can evolve well into the future.

## Features

1. Fix NEV files with erroneous event codes, based on templates.
2. Import NEV files, and convert them into "CDT table" structures.
3. Flexible design.

## CDT table structure

CDT is the data structure used in Jason and Corentin's legacy code. I don't know what CDT (cortex data tree?) stands for. However, since the structure used in this toolbox is inspired by what Corentin called CDT, I just borrow this name. In my opinion, CDT structure is not flexible, with its high dimensional cell arrays. So inspired by CDT, I use a more tabular structure to save the imported data, and call this "CDT table".

### High-level view

The CDT table structure is trial-based. Each (successful) trial in neural data corresponds to one row in the CDT table. This row is self-contained in the sense that all info about this trial can be read off this row, without any global meta info. This is different from CDT where for each kind of info about a trial (spikes, event marker times, etc.) is stored in a single variable for all trials. This difference will become clearer in an later example.

### Info in a CDT table row.
For each CDT table row, it has the following columns (fields) for the corresponding trial. Here, "in the trial" actually means happening during a specific time window in that trial (a time window of interest, rather than from start to the end of the trial)

* `condition`: condition number.
* `starttime`: the time of "start markers" in the trial, in 1 x K vector, where K is number of marker pairs.
* `stoptime`: the time of "stop markers" in the trial, in 1 x K vector.
* `spikeElectrode`: a Mx1 vector saving the electrode number of all M neurons firing during this trial.
* `spikeUnit`: a Mx1 vector saving the unit number (on corresponding electrodes) of all M neurons firing during this trial.
* `spikeTimes`: a Mx1 cell array with each cell being a row vector saving the spike time of that neuron for this trial.
* `eventCodes`: a column vector saving all event codes in this trial.
* `eventTimes`: a column vector saving all event times in this trial.

### Example of CDT table vs. CDT

Consider a NEV file with 32 channels, 40 conditions, and 10 trials per condition. For a CDT table structure, there will be 40x10=400 rows, each row having all info about that trial. For a CDT structure, There's a 32 x 40 x 10 (numChannel x numCondition x numTrial) `EVENTS` cell array, where each cell saves a row vector of the spike time of that channel on that trial of that condition. Similarly, for `starttime` (`stoptime`) in CDT table, there's a 40 x 10 `data.starttime` cell array. The disadvantages of CDT are 1) it's difficult to remember the meanings of all dimensions in that 3D `EVENTS` array or that 2D `data.starttime` array; 2) sometimes, we don't have same number of trials for each condition, so some elements in 3D or 2D arrays of CDT structure are not meaningful. Essentially, the nature of neural data is trial based, rather than a high dimensional array. In CDT table structure, since all fields are named, we don't have to remember the meanings of dimensions, and we don't have to fill in empty cells for unequal number of conditions.