function detect_edges(filename)

% close('all'); figure;

I = im2double(imread(filename));

subplot(1, 3, 1); imshow(I, []); title("original");

C = canny(I, 2, 0.1, 0.25);

subplot(1, 3, 2); imshow(C, []); title("Canny edge detector");

D = imerode(imdilate(C, strel('disk', 2, 0)), strel('disk', 1, 0));

subplot(1, 3, 3); imshow(D, []); title("edge linking (dilate + erode)");


