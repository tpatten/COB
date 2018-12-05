
%% Demo to show the results of COB UCMs

% Close figures and clear command line
close all; home

% Read an input image
%im_rgb = imread(fullfile(cob_root, 'demos','2010_005731.png'));
im_rgb = imread('ezylabel/images/img_005.png');
I = im_rgb;
% If want to use the hha features as well
hha = imread('ezylabel/hha/img_005.png');
I = cat(3, im_rgb, hha);

% Run COB. For an image of PASCALContext, it should take:
%  - less than 1s on the GPU
%  - around 8s on the CPU
tic; [ucm2, ucms, ~, O, E] = im2ucm(I); toc;

% Display result
figure;
subplot(1,2,1), imshow(im_rgb); title('Input Image');
subplot(1,2,2), imshow(ucm2(3:2:end,3:2:end).^2,[]); title('COB Ultrametric Contour Map');

%% Display orientations
figure;
for ii=1:3
    for angle = 0:0.1:pi
        % Interpolate the confidence at any given angle from the 8 bins
        conf = interpolate_confs(O.conf,angle);

        im = im_rgb+0.5*(255-im_rgb);
        conf = conf.^5;
        im(:,:,1) = (double(im(:,:,1)).*(1-conf)) + 255*conf;
        im(:,:,2) = (double(im(:,:,2)).*(1-conf));
        im(:,:,3) = (double(im(:,:,3)).*(1-conf));

        imshow(im);
        pause(0.01);
%         imwrite(im,['orient_' sprintf('%0.1f',angle) '.jpg'])
    end
end