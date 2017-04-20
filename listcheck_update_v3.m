function[]=listcheck_update_v3(statusdir,logdir,buylstdir,sellstdir,dirupdate,strategy)
%
% dirdaily Ϊ�洢ÿ�ո��µ���
% dirupdate Ϊ�洢ʵ�ʽ��׵���
% strategy Ϊ�������ƣ�Ӧ�뵥�����ڼ�Ĳ�����ͬ����tradeIC, tradeICLongOnly
%
% ���˳��

%   ������������븴���� �����ļ���
%       ���Ƶ������������������ļ���
%       �����ļ������ļ�Ӧ��Ψһ
%       �����ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ����������Ӧ���� m_
%       �����ļ����е��������Ƿ�Ϊ��ǰ������

%   �ղ���������븴���� �����ļ���
%       ���Ƶ������뵥�����ն��ļ���
%       �ն��ļ������ļ��Ƿ�Ψһ
%       �ն��ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ
%       �ն��ļ����е��������뵱�������Ƿ���ͬ

%   ���ֲ�λ�����
%       �����·���Ӧ�ø��Ƶ��ն��ļ���
%       ������Ӧ���Ƶ������ļ���

% ����������־ log.txt

logid=fopen(logdir,'a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
msg2='��ǰ���³���汾 V3.0';
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'%s\n\r',msg2);
fprintf(logid,'\n\r');
display(msg);
display(msg2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��鵱ǰ��λ״̬ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cwstate=importdata(statusdir);
[levels,~]=size(cwstate);
currentstate=sum(cwstate(:,1)~=0);
%������ȫΪ0����������

todaydt=datestr(today(),'yyyymmdd');
updtname='�����ļ���';
sellpfx='m_';
sellftp='.csv';
buypfx='';
buyftp='.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if currentstate == levels  %�����ֵ������
    %%%%%%%%%% ���������ĵ��������������ļ��У�����ӦΪ��ǰ�����գ���������ǰӦ��m_,�����ļ������ļ�ӦΨһ  %%%%%%%%
    msg=['Ŀǰ���֣�Ӧ����Ψһ���� ' sellpfx strategy todaydt sellftp '�������ļ���'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errsell=copy_trdlist(logid,sellstdir,dirupdate,updtname,true,sellpfx,strategy,todaydt,sellftp,1,false);
    if errsell==0
        display('�������Ƴɹ���');
    end
    
elseif currentstate==0  % ���޳ֲֵ�����£�
    %%%%%%%%%%%%%%%% ���Ʒ��͵ĵ������������ļ��У���������ӦΪ��ǰ���ڣ�����ӦΨһ %%%%%%%%%%%%%
    msg=['Ŀǰ�ղ֣�Ӧ����Ψһ�� ' buypfx strategy todaydt buyftp '�������ļ���'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errbuy=copy_trdlist(logid,buylstdir,dirupdate,updtname,true,buypfx,strategy,todaydt,buyftp,1,false);
    if errbuy==0
        display('�򵥸��Ƴɹ���');
    end

else   % �ڲ��ֲֳֵ������
    msg=['Ŀǰ���� ' num2str(currentstate) ' ������' num2str(levels) '������Ҫ���򵥺����� �����Ƶ������ļ���'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errsell=copy_trdlist(logid,sellstdir,dirupdate,updtname,true,sellpfx,strategy,todaydt,sellftp,1,false);
    errbuy=copy_trdlist(logid,buylstdir,dirupdate,updtname,false,buypfx,strategy,todaydt,buyftp,2,false);
    if errbuy==0 && errsell==0
        display('���������Ƴɹ���');
    end
    
end
fclose(logid);







