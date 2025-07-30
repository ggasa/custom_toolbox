## Custom toolbox for extracting BrainSenseSurvey Data from Percept Device JSON files





Author: Dan Kim 





#### A guide to using the custom_toolbox

*Purpose of this code: 
Extracts BrainSenseSurvey data from Medtronic's Percept Device JSON exports (LfpMontageTimeDomain and LfpMontage).
Saves it into matlab figures, plots(png), .m datafile, and a patient summary information table.

How to Use
1. Set the pathname to the folder containing toolbox.m file
    ex. 'C:/Users/rlaan/custom_toolbox/' -> 'your computer's path'
2. Run the matlab file, toolbox.m
3. You can select multiple JSON files, the location doesn't matter (they don't have to be in the same folder as the toolbox).
 !Please keep the name of the json files as sub-XXXXXXXX_XX.json. Information is extracted from the filename
                                      Ex. sub-EMOPXXXX_test.json
                                      Ex2. sub-EMOPXXXX_.json
4. When successfully ran, the result will be folders consisting of each subject name.
   Inside each folder there will be PSD and LFP plots, spectrograms, .m data. Outside of the each patient specfic folder there will be a "subject_summary_combined.xlsx" file,
   which summarizes relevant subject information. "subject_summary_combined.xlsx" file will combine new information everytime a new patient is added (ran) automatically.
   This is information extracted from patient's Initial Group settings, which would be the settings the patient had been under influence of of before the BrainSenseSurvey.
