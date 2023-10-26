clc, clear all, close all;

imds = imageDatastore('./DATASET/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

datas = cell(numel(imds.Files)+1, 11);
datas(1, :) = {'FileName', 'Contrast', 'Dissimilarity', 'Homogeneity', 'AngularSecondMoment', 'Energy', 'MaxGLCM', 'Entropy', 'GLCMMean', 'GLCMVar', 'GLCMCorrelation'};


for i = 1:numel(imds.Files)
    filename = imds.Files{i};
    [filepath,name,ext] = fileparts(filename)
    data = feature_detection(filename);

    datas(i+1, :) = [{name}, num2cell(data)];
end

writecell(datas, [datestr(now, 'yyyy_mm_dd-HH_MM_SS'), '.xlsx']);
