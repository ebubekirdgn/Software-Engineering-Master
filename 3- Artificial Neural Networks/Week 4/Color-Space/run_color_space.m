clc, clear all, close all;

imds = imageDatastore('DATASET/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

datas = cell(numel(imds.Files)+1, 61);

datas(1, :) = {'FileName', 'Mean_RGB_R', 'Mean_RGB_G', 'Mean_RGB_B', 'STD_RGB_R', 'STD_RGB_G', 'STD_RGB_B', 'Entropy_RGB_R', 'Entropy_RGB_G', 'Entropy_RGB_B', 'Skew_RGB_R', 'Skew_RGB_G', 'Skew_RGB_B', ...
                           'Mean_HSV_H','Mean_HSV_S','Mean_HSV_V','STD_HSV_H','STD_HSV_S','STD_HSV_V','Entropy_HSV_H','Entropy_HSV_S','Entropy_HSV_V','Skew_HSV_H','Skew_HSV_S','Skew_HSV_V', ... 
                           'Mean_YCbCr_Y','Mean_YCbCr_Cb','Mean_YCbCr_Cr','STD_YCbCr_Y','STD_YCbCr_Cb','STD_YCbCr_Cr', 'Entropy_YCbCr_Y','Entropy_YCbCr_Cb','Entropy_YCbCr_Cr','Skew_YCbCr_Y','Skew_YCbCr_Cb','Skew_YCbCr_Cr', ...
                           'Mean_LAB_L',  'Mean_LAB_A',  'Mean_LAB_B', 'STD_LAB_L','STD_LAB_A','STD_LAB_B','Entropy_LAB_L','Entropy_LAB_A','Entropy_LAB_B', 'Skew_LAB_L','Skew_LAB_A','Skew_LAB_B', ...
                           'Mean_XYZ_X','Mean_XYZ_Y','Mean_XYZ_Z','STD_XYZ_X','STD_XYZ_Y','STD_XYZ_Z','Entropy_XYZ_X','Entropy_XYZ_Y','Entropy_XYZ_Z','Skew_XYZ_X','Skew_XYZ_Y','Skew_XYZ_Z'};

for i = 1:numel(imds.Files)
    filename = imds.Files{i};
    data = color(filename);

    datas(i+1, :) =[{filename}, num2cell(data)];
end

writecell(datas, [datestr(now, 'yyyy_mm_dd-HH_MM_SS'), '.xlsx']);