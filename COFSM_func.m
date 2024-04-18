function [cleanedPoints3,cleanedPoints4]=COFSM_func(image_1,image_2)

addpath(genpath('CoFSM'));

%% 1 Initial parameters setting
sigma_s=10;                 % The main parameters of co-occurrence filtering: filter initial window size [3, 5, 10]
sigma_1=1.6;              % Scale of the first layer: 1.6
ratio=2^(1/3);             % scale ratio
Mmax=3;                    % the number of layers in the scale space 4
first_layer=1;               % extreme point detection start layer number
d_SH=1300;                % Feature point extraction threshold size [500, 1000, 1300, 1500, 2000] 1300
change_form='Affine'; % 'Similarity'，'Affine';

disp('Start processing, please waiting...');
%% 2 Convert input image format
[~,~,num1]=size(image_1);
[~,~,num2]=size(image_2);
if(num1==3)
    image_11=rgb2gray(image_1);
else
    image_11=image_1;
end
if(num2==3)
    image_22=rgb2gray(image_2);
else
    image_22=image_2;
end
image_11=double(image_11(:,:,1));
image_22=double(image_22(:,:,1));

tic
%% 3 Create create_CoOcurscale_space  
[CoOcurscale_space_1]=Create_CoOcurScale_space(image_11,sigma_1,Mmax,ratio,sigma_s);
[CoOcurscale_space_2]=Create_CoOcurScale_space(image_22,sigma_1,Mmax,ratio,sigma_s);
time1=toc;

tic
%% 4 Feature point extraction and matching
[H,rmse,cor2,cor1] =CoFSM(CoOcurscale_space_1,CoOcurscale_space_2,d_SH,sigma_1,ratio,first_layer,change_form);
time2=toc;

cleanedPoints3=cor1(:,1:2); cleanedPoints4=cor2(:,1:2);

end

