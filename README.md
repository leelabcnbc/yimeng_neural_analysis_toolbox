yimeng_neural_analysis_toolbox
==============================


## Introduction
A package for analzying (now mainly for importing) NEV/CTX data, mostly written in MATLAB.

## Motivation

The existing analysis tools (used by Jason and Corentin) are not flexible or well-structured. The biggest problem is that, code change is necessary for each different experiment. To import data for an new experiment, a considerable amount of code has to be modified. When importing data of old experiments, the code has to be modified again, all over different files. This makes our data import extremely difficult to reproducible and debug. Therefore, based on existing code, I want to make a better package for importing neural data. I hope that this code can evolve well into the future.

## Features

1. Fix NEV files with erroneous event codes, based on a template file.
2. Import NEV files, converting them into "CDT table" structures.
3. Flexible design.

## CDT table structure

### CDT

I don't know what CDT (cortex data tree?) stands for. However, since the structure used in this toolbox is inspired by what Corentin called CDT, I just borrow this name.

### CDT table

In my opinion, CDT structure is not flexible, with its high dimensional cell arrays. So inspired by CDT, I use a more tabular structure to save the imported data, and call this "CDT table".

