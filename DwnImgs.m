clc; close all; clear all; warning off;
%%
GTPath = 'GT_AVA/AVA_GT.mat';
outDir = 'Imgs/';
ImgGTDir = 'ImgsGT/';
%%
if exist(outDir, 'dir')
    rmdir(outDir,'s');
end
mkdir(outDir);
if exist(ImgGTDir, 'dir')
    rmdir(ImgGTDir,'s');
end
mkdir(ImgGTDir);
%%
SymGT = load(GTPath);
FileNames = SymGT.new_cell_GT(:,1);
SymEll = SymGT.new_cell_GT(:,2); % [x1,y1,x2,y2]

%%
for i=1:numel(FileNames)
    file = strtrim(FileNames{i});
    [~,name,~] = fileparts(file);
    disp(['Downloading ' num2str(i) ' of ' num2str(numel(FileNames)) ...
        ' : ' name]);
    url = ['http://www.dpchallenge.com/image.php?IMAGE_ID=' name];
    fullList = webread(url);
    [stInd,edInd] = regexp(fullList,['/><img src="(.*?)' file '" width=']);
    imgUrl = fullList(stInd+12:edInd-8);
    outfilename = websave([outDir file],imgUrl);
    
    stPntGT = SymEll{i}(1,[1,2]);
    edPntGT = SymEll{i}(1,[3,4]);
    cnPntGT = [(stPntGT(1)+edPntGT(1))/2, (stPntGT(2)+edPntGT(2))/2];
    
    img = imread([outDir file]);
    figure('Visible', 'off'); imshow(img); hold on;
    plot([stPntGT(1) edPntGT(1)],[stPntGT(2) edPntGT(2)],'-bs');
    plot(cnPntGT(1), cnPntGT(2),'bx');
    hold off;
    saveas(gcf,[ImgGTDir name '-GTAxis.png']);
    close all;
end
disp('Done!!');