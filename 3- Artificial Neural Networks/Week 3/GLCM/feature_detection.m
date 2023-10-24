function rdatas = feature_detection(filename)
    I = imread(filename);
    A = rgb2gray(I);

       
    %OFSET AND YÖN
    Displacementx = -1;
    Displacementy = 1;
    
    
      
    As = (A-min(A(:)))+1;
    
    NumQuantLevels = max(As(:));
    glcm = zeros([NumQuantLevels,NumQuantLevels]);
    
    if ( Displacementx < 0 ) 
        sx=abs(Displacementx)+1;
        ex=size(As,1);
    else
        sx=1;
        ex=size(As,1)-Displacementx;
    end
    
    if ( Displacementy < 0 ) 
        sy=abs(Displacementy)+1;
        ey=size(As,2);
    else
        sy=1;
        ey =size(As,2)-Displacementy;
    end
    for i=sx:ex
        for j=sy:ey
            glcm(As(i,j),As(i+(1*Displacementx),j+(1*Displacementy)))=glcm(As(i,j),As(i+(1*Displacementx),j+(1*Displacementy)))+1;
        end
    end
    
    
    
    GLCMProb = glcm./sum(glcm(:));
    [jj,ii]=meshgrid(1:size(glcm,1),1:size(glcm,2));
    ij=ii-jj;
    
    Con = sum(sum(GLCMProb.*(ij).^2));
    Diss = sum(sum(GLCMProb.*abs(ij)));
    Hom = sum(sum(GLCMProb./(1+(ij).^2)));
    Asm = sum(sum(GLCMProb.^2));     
    Meanx = sum(sum(GLCMProb.*ii)); 
    Meany = sum(sum(GLCMProb.*jj));        
    
    Energy = sqrt(Asm);
    MaxGLCM = max(GLCMProb(:));
    Entropy = sum(sum(-GLCMProb .* log10(GLCMProb+0.00001)));
    GLCMMean = (Meanx+Meany)/2;
    
    Varx = sum(sum(GLCMProb.*(ii-Meanx).^2));
    Vary = sum(sum(GLCMProb.*(jj-Meany).^2));
    
    GLCMVar = (Varx+Vary)/2;
    
    GLCMCorrelation = sum(sum(GLCMProb.*(ii-Meanx).*(jj-Meany)/sqrt(Varx*Vary)));

    rdatas = [Con, Diss, Hom, Asm, Energy, MaxGLCM, Entropy, GLCMMean, GLCMVar, GLCMCorrelation];

    
%     BW = edge(I, 'canny', 0.4);
%     total = bwarea(BW);
%     [H, theta, rho] = hough(BW);
%     
%     peaks = houghpeaks(H, 5, 'threshold', ceil(0.3 * max(H(:))));
%     lines = houghlines(BW, theta, rho, peaks, 'FillGap', 5, 'MinLength', 7);
%     
%     n = vecnorm([cell2mat({lines.point1}') - cell2mat({lines.point2}')]');
%     rdatas = [numel(lines), max(n), total];
end
