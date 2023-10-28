function feature_list = color(image)
    I = imread(image);
    % I2 = imread('lena.jpg');
    
    % RGB Özellikleri
   
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    meanR = mean2(R);
    meanG = mean2(G);
    meanB = mean2(B);

    stdR = std2(R);
    stdG = std2(G);
    stdB = std2(B);

    entropyR = entropy(R);
    entropyG = entropy(G);
    entropyB = entropy(B);

    R2 = im2double(R);
    G2 = im2double(G);
    B2 = im2double(B);

    skw_R = skewness(R2(:));
    skw_G = skewness(G2(:));
    skw_B = skewness(B2(:));

    % HSV Özellikleri

    HSV = rgb2hsv(I);
    
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);

    meanH = mean2(H);
    meanS = mean2(S);
    meanV = mean2(V);

    stdH = std2(H);
    stdS = std2(S);
    stdV = std2(V);

    entropyH = entropy(H);
    entropyS = entropy(S);
    entropyV = entropy(V);

    H2 = im2double(H);
    S2 = im2double(S);
    V2 = im2double(V);

    skw_H = skewness(H2(:));
    skw_S = skewness(S2(:));
    skw_V = skewness(V2(:));

    % YCbCr Özellikleri

    YCbCr = rgb2ycbcr(I);

    Y = YCbCr(:,:,1);
    Cb = YCbCr(:,:,2);
    Cr = YCbCr(:,:,3);

    meanY = mean2(Y);
    meanCb = mean2(Cb);
    meanCr = mean2(Cr);

    stdY = std2(Y);
    stdCb = std2(Cb);
    stdCr = std2(Cr);

    entropyY = entropy(Y);
    entropyCb = entropy(Cb);
    entropyCr = entropy(Cr);

    Y2 = im2double(Y);
    Cb2 = im2double(Cb);
    Cr2 = im2double(Cr);

    skw_Y = skewness(Y2(:));
    skw_Cb = skewness(Cb2(:));
    skw_Cr = skewness(Cr2(:));

    % LAB Özellikleri

    Lab = rgb2lab(I);

    L = Lab(:,:,1);
    A = Lab(:,1,:);
    B2 = Lab(1,:,:);

    meanL = mean2(L);
    meanA = mean2(A);
    meanB2 = mean2(B2);

    stdL = std2(L);
    stdA = std2(A);
    stdB2 = std2(B2);

    entropyL = entropy(L);
    entropyA = entropy(A);
    entropyB2 = entropy(B2);

    L2 = im2double(L);
    A2 = im2double(A);
    B22 = im2double(B2);

    skw_L = skewness(L2(:));
    skw_A = skewness(A2(:));
    skw_B2 = skewness(B22(:));

    % XYZ Özellikleri

    XYZ = rgb2xyz(I);

    X = XYZ(:,:,1);
    XY = XYZ(:,1,:);
    Z = XYZ(1,:,:);

    meanX = mean2(X);
    meanXY = mean2(XY);
    meanZ = mean2(Z);

    stdX = std2(X);
    stdXY = std2(XY);
    stdZ = std2(Z);

    entropyX = entropy(X);
    entropyXY = entropy(XY);
    entropyZ = entropy(Z);

    X2 = im2double(X);
    XY2 = im2double(XY);
    Z2 = im2double(Z);

    skw_X = skewness(X2(:));
    skw_XY = skewness(XY2(:));
    skw_Z = skewness(Z2(:));

    feature_list = [meanR, meanG, meanB, stdR, stdG, stdB, entropyR, entropyG, entropyB, skw_R, skw_G, skw_B ...
                    meanH, meanS, meanV, stdH, stdS, stdV, entropyH, entropyS, entropyV, skw_H, skw_S, skw_V ...
                    meanY, meanCb, meanCr, stdY, stdCb, stdCr, entropyY, entropyCb, entropyCr, skw_Y, skw_Cb, skw_Cr ...
                    meanL, meanA, meanB2, stdL, stdA, stdB2, entropyL, entropyA, entropyB2, skw_L, skw_A, skw_B2 ...
                    meanX, meanXY, meanZ, stdX, stdXY, stdZ, entropyX, entropyXY, entropyZ, skw_X, skw_XY, skw_Z];

end