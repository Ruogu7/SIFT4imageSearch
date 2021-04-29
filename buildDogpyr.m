%% 创建Dog金字塔
%
%
%%
function Dogpyr = buildDogpyr(gausspyr)
global Octave Layers;
Oct = Octave;D = Layers+2;
Dogpyr = cell(Oct,1) ;
for oct = 1:1:Oct
    for lay = 1:1:D
        %%  图片数据如何归一化 ？？？
        % 图片不归一化目的是后面的极值点判断时，归一化以后原来在0附近的点都被错误的线性化了。
        Dogpyr{oct}(:,:,lay) = gausspyr{oct}(:,:,lay+1) - gausspyr{oct}(:,:,lay);
      
        % 将图片归一化到（0-1）  如果想显示并查看Dog金字塔图像 归一化显示否则不归一化的图片很可能将显示的一片黑
% %         laymax = max(max(Dogpyr{oct}(:,:,lay)));
% %         laymin = min(min(Dogpyr{oct}(:,:,lay)));
% %         [oct lay laymax laymin] %用于查看dog塔中各层之间的最大最小值，便于人工通过数据感官其稳定性
%            % 因为有过考虑毕竟不是Log图，担心Dog层与层之间相差一个常数（k-1）sigma*sigma，从而引起极值点都跑到某一个层里面
%            % 经过实验对比发现貌似担心是多余的，但还没有严格的数学证明
%         Dogpyr{oct}(:,:,lay) = (Dogpyr{oct}(:,:,lay)-laymin)/(laymax-laymin);
%         Dogpyr{oct}(:,:,lay) = 2*(Dogpyr{oct}(:,:,lay)-laymin)/(laymax-laymin)-1;
    end
end