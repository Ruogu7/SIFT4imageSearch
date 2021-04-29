function [flagbool kpt] = adjustExtrPoint(Dogpyr,gausspyr,oct,lay1,r1,c1)
global Layers;
global edgegama; %�Ƿ��������Ե�жϵ�gammaϵ��
global SIFT_STEP; %��������
global IterationMax; %���һ���ϴ�ֵ
global ExtrThreshold; %��ֵ���ȶ��ж�
global SIFT_Img_Border; %ͼƬ�߽�ȥ��SIFT_Img_Border-1�����ص�

flagbool = 0;
kpt = [];
lay = lay1;r = r1;c = c1;  %������λ����Ϣ�ǻ��ʵ������� ����oct�ǲ��������

for step = 1:1:SIFT_STEP  %ѭ������
    cub_pre = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay-1);
    cub_at = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay);
    cub_next = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay+1);
    dx = 1/2 * ( cub_at(2,3)-cub_at(2,1) );
    dy = 1/2 * ( cub_at(3,2)-cub_at(1,2) );
    ds = 1/2 * ( cub_next(2,2)-cub_pre(2,2) );
    Dx = [dx;dy;ds];
    atv2 = cub_at(2,2)*2;
    dxx = (cub_at(2,3)+cub_at(2,1)-atv2);
    dyy = (cub_at(3,2)+cub_at(1,2)-atv2);
    dss = (cub_next(2,2)+cub_pre(2,2)-atv2);
    dxy = (cub_at(3,3)+cub_at(1,1)-cub_at(3,1)-cub_at(1,3))/4;
    dxs = (cub_next(2,3)-cub_next(2,1)-cub_pre(2,3)+cub_pre(2,1))/4;
    dys = (cub_next(3,2)-cub_next(1,2)-cub_pre(3,2)+cub_pre(1,2))/4;
    H = [dxx dxy dxs; ...
        dxy dyy dys; ...
        dxs dys dss];
    Det = -inv(H)*Dx;
    dr = Det(1); dc = Det(2); di = Det(3);
    if abs(dr)<0.5 && abs(dc)<0.5 && abs(di)<0.5
        flagbool = 1;
        break;
    end
    if abs(dr)>IterationMax || abs(dc)>IterationMax || abs(di)>IterationMax
        flagbool = 0;
        break;
    end
    lay = round(lay+di); r = round(r+dr); c = round(c+dc);
    %ͬһ���ڵ�ͼƬ����������ͬ������ȡ��1�㡣������lay�㣨�������й�����round(lay+di)���ܷǺ�������
    [rows cols] = size(Dogpyr{oct}(:,:,1));  
    % ��ֵ�����ֻ����Dog���еĵ�2��s+1��Ѱ�ң����¶�Ҫ�бȽϲ㣩
    if lay<2 || lay >Layers+1 || ...
            r<SIFT_Img_Border || r>rows-SIFT_Img_Border+1 || ...
            c<SIFT_Img_Border || c>cols-SIFT_Img_Border+1
        flagbool = 0;
        break;
    end
end
%����forѭ��������ҵ��˼�ֵ��flagbool == 1


%%
%Ҳֻ�е�������С��Ԥ��ֵ��abs(dr)<0.5 && abs(dc)<0.5 && abs(di)<0.5ʱ
%�Ż���������if�������������Ĵ�����Էŵ�����ġ�flagbool = 1;�����ǰ
if flagbool == 1
    fx = Dogpyr{oct}(r,c,lay)+1/2*Dx'*Det;
    laymax = max(max(Dogpyr{oct}(:,:,lay)));
    laymin = min(min(Dogpyr{oct}(:,:,lay)));
    stable = ExtrThreshold*max( abs(laymax),abs(laymin) );
    if abs(fx) < stable
        flagbool = 0;
    end
    % ����Hessian������OpenCV�в�ͬ����ͨ��gausspyr��Hessian����
    % ����Ϊ�߽�Ӧ�ö�ͼ������˵��ͬʱDog�������ǲ���ټ�����֣����߽ײ����ʧ���Ƿǳ����
    % ���������,Dog��ֵ���Ӧ��˹���ı�����(��ΪDog��Log�ı������������˹��ֵĽ���)��
    % ����Ϊ�˷�ֹƫ�����ֵ����Χ�Ÿ��㶼�ж��ǲ������ڱ߽���
    for rh = r-1:1:r+1
        for ch = c-1:1:c+1
%     for rh = r
%         for ch = c
            Hcub = gausspyr{oct}(rh-1:rh+1,ch-1:ch+1,lay);
            Hxx = Hcub(2,3)+Hcub(2,1)-2*Hcub(2,2);
            Hyy = Hcub(3,2)+Hcub(1,2)-2*Hcub(2,2);
            Hxy = (Hcub(3,3)+Hcub(1,1)-Hcub(1,3)-Hcub(3,1))/4;
            tr = Hxx+Hyy;
            Hdet = Hxx*Hyy-Hxy*Hxy;
            if Hdet <=0 || tr*tr/Hdet >= (edgegama+1)*(edgegama+1)/edgegama
                flagbool = 0;
            end
        end
    end
end
%%  ��ֵ�������ȷ��λ�ȶ����Ҳ����ڱ߽����������ʱ
if  flagbool == 1
    kpt = [oct lay r c di dr dc];  %���ڵ��顢�㡢�С��С��Լ����㡢�С��У���΢Сƫ��
end













