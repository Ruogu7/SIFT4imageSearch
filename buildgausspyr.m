%%  ������˹������
% OpenCV���ں˵Ĵ�С���㷽����
%   ksize.height = cvRound(sigma2*(depth == CV_8U ? 3 : 4)*2 + 1)|1;
%    CV_Assert( ksize.width > 0 && ksize.width % 2 == 1 &&
%         ksize.height > 0 && ksize.height % 2 == 1 );//ȷ���˿�ͺ˸�Ϊ������
% cell �����������
% A = cell(numArrays,1);
% for n = 1:numArrays
%     A{n} = magic(n);
% end
%%
function gausspyr = buildgausspyr(Imagedb)
global Octave Layers;
global sigma;
Oct = Octave;S = Layers+3; 

gausspyr = cell(Oct,1) ;
for oct = 1:1:Oct
    clear gausspyr_oct  gauss_at_1;
    for lay = 1:1:S
        ksize = 2*sigma(1,lay)*3+1; % �˲��ں˷�Χ
        ksize = 2*round(ksize/2-0.5)+1; % �˲��ں�ȷ��Ϊ����
        at = lay;
        if oct == 1 && lay == 1
        w=fspecial('gaussian',[ksize ksize],sigma(1,lay));
        gausspyr_oct(:,:,at) = imfilter(Imagedb,w,'same');
        else if oct >= 1 && lay >= 2
                w=fspecial('gaussian',[ksize ksize],sigma(1,lay));
                gausspyr_oct(:,:,at) = imfilter(gausspyr_oct(:,:,at-1),w,'same');
            else if  oct >= 2 && lay == 1                    
                    gauss_at_1 =  gausspyr{oct-1}(:,:,S-2) ;  % ǰһ�鵹��������
                    gauss_at = imresize(gauss_at_1,0.5,'bilinear');
                    gausspyr_oct(:,:,at) = gauss_at;
                end
            end
        end        
    end
    gausspyr{oct} = gausspyr_oct;
end



