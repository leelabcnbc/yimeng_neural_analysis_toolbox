yimeng_neural_analysis_toolbox
==============================


## Introduction
A set of tools for analyzing neural data.

## Motivation

In my opinion, the existing analysis tools are not flexible or well-structured. Therefore, based on existing code, I want to make a better toolbox for analyzing neural data. I hope that this code can evolve well into the future. 

## Features

1. Fix NEV files with erroneous event codes, based on the corresponding timing file and condition file.
2. Import NEV files, converting them into CDT structures.
3. Simple analysis and plotting
4. Flexible design

## CDT structure

I don't know what CDT stands for. However, since the structure used in this toolbox is inspired by what Corentin called CDT, I just borrow this name.

*under construction*

## Import

When converting NEV file into CDT structure, the toolbox depends on two "databases": a recording database and an experiment parameter database.

The recording database stores the **file-specific** information needed for importing every NEV file, and the experiment parameter database stores **experiment-specific** parameters for experiments that NEV files are associated with.

Both databases are written in CSV files.

### Recording database file

This file stores the **file-specific** information needed for importing every NEV file. I call it recording database file, not NEV database file, due to the possible extension of this toolbox to handle NS2 and other formats other than NEV.


Each file's information occupies one line, and each line contains four fields.

* **key** a unique identifier of this recording. If omitted, it's just **NEV_name** without extension.
* **NEV_name** the name of NEV file for this recording.
* **exp_name** the name (key) of the associated experiment.
* **comment** any other comment.

In the initial version of this toolbox, each line contains some other fields, like "monkey", "rf", "neuron", etc. However, I think it's better to put all these under a single field **comment**.

### Experiment parameter file

This file stores **experiment-specific** parameters for experiments that NEV files are associated with. Each experiment's information occupies one line, and each line contains seven fields.

* **exp_name** the name (key) of the associated experiment. Must match the one in the recording database file.
* **condition_number** the condition numbers used in this experiment. The toolbox currently assumes that the condition numbers are consecutive, e.g. 1-16, 3-45, but not (1-12, 14-16). Here, only the smallest and the largest numbers are provided.
* **number_of_test_per_condition** number of different tests done for one condition. In some experiments, one condition in CORTEX actually maps to 2 or more "real" conditions.
* **align_code** the start and stop codes for all tests in one trial. Written in format **"start1 stop1 start2 end2 …"** There should be **2*number_of_test_per_condition** codes in this field.
* **start_stop_code** two codes specifying the interval in which spikes and event codes are stored in the CDT structure. If omitted, the start code will be the first code in **align_code**, and the stop code will be the last code in **align_code**.
* **timing_file** name of the associated timing file.
* **condition_file** name of the associated condition file.

