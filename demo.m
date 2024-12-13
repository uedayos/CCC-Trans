clear
close all
clc

%%
I = im2double(imread("./01.png"));

I_out = ccc_trans(I);

figure, imshow(I), title('original image')
figure, imshow(I_out), title('resultant image of ccc-trans')
