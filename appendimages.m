% 这个函数来源于LOWE的主页，别害怕！仅仅是个最简单的图片拼接
%
% 

function im = appendimages(image1, image2)

% Select the image with the fewest rows and fill in enough empty rows
%   to make it the same height as the other image.
rows1 = size(image1,1);
rows2 = size(image2,1);

if (rows1 < rows2)
     image1(rows2,1) = 0;  %虽然只增补最后的一行，实际上中间的区域也自动补零。
else
     image2(rows1,1) = 0;
end

% Now append both images side-by-side.
im = [image1 image2];   
