%% ����Dog������
%
%
%%
function Dogpyr = buildDogpyr(gausspyr)
global Octave Layers;
Oct = Octave;D = Layers+2;
Dogpyr = cell(Oct,1) ;
for oct = 1:1:Oct
    for lay = 1:1:D
        %%  ͼƬ������ι�һ�� ������
        % ͼƬ����һ��Ŀ���Ǻ���ļ�ֵ���ж�ʱ����һ���Ժ�ԭ����0�����ĵ㶼����������Ի��ˡ�
        Dogpyr{oct}(:,:,lay) = gausspyr{oct}(:,:,lay+1) - gausspyr{oct}(:,:,lay);
      
        % ��ͼƬ��һ������0-1��  �������ʾ���鿴Dog������ͼ�� ��һ����ʾ���򲻹�һ����ͼƬ�ܿ��ܽ���ʾ��һƬ��
% %         laymax = max(max(Dogpyr{oct}(:,:,lay)));
% %         laymin = min(min(Dogpyr{oct}(:,:,lay)));
% %         [oct lay laymax laymin] %���ڲ鿴dog���и���֮��������Сֵ�������˹�ͨ�����ݸй����ȶ���
%            % ��Ϊ�й����ǱϾ�����Logͼ������Dog�����֮�����һ��������k-1��sigma*sigma���Ӷ�����ֵ�㶼�ܵ�ĳһ��������
%            % ����ʵ��Աȷ���ò�Ƶ����Ƕ���ģ�����û���ϸ����ѧ֤��
%         Dogpyr{oct}(:,:,lay) = (Dogpyr{oct}(:,:,lay)-laymin)/(laymax-laymin);
%         Dogpyr{oct}(:,:,lay) = 2*(Dogpyr{oct}(:,:,lay)-laymin)/(laymax-laymin)-1;
    end
end