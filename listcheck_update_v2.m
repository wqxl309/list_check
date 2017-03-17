function[]=listcheck_update_v2(statusdir,logdir,dirdaily,dirupdate,strategy)
%
% dirdaily Ϊ�洢ÿ�ո��µ���
% dirupdate Ϊ�洢ʵ�ʽ��׵���
% strategy Ϊ�������ƣ�Ӧ�뵥�����ڼ�Ĳ�����ͬ����tradeIC,tradeICLongOnly
%
% ���˳��
%   �ȸ��Ƶ����յ��Ľ��׵��ӵ� �ն��ļ��У������Ƿ��гֲ�
%       ����ǰ��ɾ�������ļ�������Ƿ�ɾ���ɹ�
%       ��ɾ���ɹ����ƣ���鸴���Ƿ�ɹ����Ҹ��Ƶĵ��ӵ�����Ϊ������ ����
%   �гֲ�������������ļ���
%       ���Ƶ������������������ļ���
%       �����ļ������ļ��Ƿ�Ψһ
%       �����ļ����Ƿ�Ϊ��
%       �����ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ����������Ӧ���� m_
%       �����ļ����е��������Ƿ�Ϊ��ǰ������
%   �޳ֲ����������ն��ļ���
%       �ն��ļ������ļ��Ƿ�Ψһ
%       �ն��ļ����Ƿ�Ϊ��
%       �ն��ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ
%       �ն��ļ����е��������뵱�������Ƿ���ͬ
%       ������ȷ��׼�����и��ƣ�
%            ����ǰ����ɾ�������ļ����������ļ������ɾ���Ƿ�ɹ���
%            ��ɾ���ɹ����ƣ���鸴���Ƿ�ɹ�
%       ��¼���Ƶ��ļ��ж�Ӧʱ��
%
% ����������־ log.txt

logid=fopen(logdir,'a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'\n\r');

cwstate=importdata(statusdir);
%������ȫΪ0����������


%%%%%%%%%%%%%%%%%%%%%%%%%  ���Ƶ������ն��ļ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ƿ�ʼǰ��������ն��ļ���,ɾ������ CSV �ļ�
[rmstatus,rmmsg]=system(['del ',dirdaily,'\*.csv']);
if rmstatus~=0
    msg=['�ն��ļ������ʧ�ܣ�����ԭ�� ' rmmsg];
    logupdt_erroutpt(logid,msg);
else
    msg='�ն��ļ�������ɹ�,��������';
    fprintf(logid,'%s\n\r',msg);
    fprintf(logid,'\n\r');
    display(msg);
end
% ��������ʼ�����ļ�
todaydt=datestr(today(),'yyyymmdd');
[cpstatus,cpmsg]=system(['copy \\ACERPC\tradelist\',strategy ,todaydt, '.csv ',dirdaily]);
if cpstatus ~=0
    msg=['����ʧ�ܣ�����ԭ��' cpmsg];
    logupdt_erroutpt(logid,msg);
else
    msg=['���Ƴɹ�����ǰ�ն��ļ����е�������Ϊ ', todaydt];
    fprintf(logid,'%s\n\r',msg);
    fprintf(logid,'\n\r');
    fprintf(logid,'\n\r');
    display(msg);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��鵱ǰ״̬ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
currentstate=cwstate(end,1);

if currentstate ~= 0  %���гֲֵ������
    %%%%%%%%%% ���������ĵ�������������ӦΪ��ǰ�����գ���������ǰӦ��m_  %%%%%%%%
    % ���ƿ�ʼǰ������ո����ļ���,ɾ�� CSV �����ļ�
    [rmstatus,rmmsg]=system(['del ',dirupdate,'\*.csv']);
    if rmstatus~=0
        msg=['�����ļ������ʧ�ܣ�����ԭ�� ' rmmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg='�����ļ�������ɹ�,��������';
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        display(msg);
    end
    % ��������ʼ���� ĿǰΪ CSV �ļ�
    [cpstatus,cpmsg]=system(['copy \\ACERPC\updtlist\m_',strategy ,todaydt, '.csv ',dirupdate]);
    if cpstatus ~=0
        msg=['����ʧ�ܣ�����ԭ��' cpmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg=['���Ƴɹ�����ǰ�����ļ����е�������Ϊ ', todaydt];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end    
    %%%%%%% ������ɺ� �������ļ������ļ��Ƿ�Ψһ �� �Ƿ�Ϊ�� %%%%%%%%
    updtfiles=ls(dirupdate);
    [num,~]=size(updtfiles);
    % ����ļ��Ƿ�Ψһ
    if num>3  
        msg=['��ǰ�����ļ������� ',num2str(num-2),' ���ļ���Ӧֻ����Ψһ����µ��ļ�����'];
        logupdt_erroutpt(logid,msg);
    end
    % ����ļ����Ƿ�Ϊ��
    updttrdlist=updtfiles(end,:);
    if strcmp(strrep(updttrdlist,' ',''),'..')   
        msg='�����ļ���Ϊ�գ�����';
        logupdt_erroutpt(logid,msg);  
    end
    %%%%%%%% ��ʱ��ͨ���������飬ȷ���ļ������ļ�������Ψһ����鵥�ӱ��� %%%%%%%%
    listdate=updttrdlist(end-11:end-4);
    listname=updttrdlist(1:end-12);
    % ��鵱ǰ�����ļ����ļ���ӦΪ m_ + strategy    
    if ~strcmp(['m_' strategy],listname) % ����Ƿ���ڵ��ӷŴ��Ӧ����
        msg=['�����ļ����У����Ӳ��Դ���ӦΪ m_' ,strategy,' ����ǰΪ ',listname,' ������'];      
        logupdt_erroutpt(logid,msg);  
    end
    % ����Ƿ���ڵ������ڣ�ӦΪ��ǰ����
    % currentdate=datestr(today(),'yyyymmdd');
    if ~strcmp(listdate,todaydt) 
        msg=['�����ļ����У��������ڴ���ӦΪ ', todaydt,' ��ǰΪ ',listdate,' ������'];
        logupdt_erroutpt(logid,msg);
    end        
    %%%%%%%%% �����ɣ����������� %%%%%%%%%%%
    msg=['��ǰ�����ļ����еĴν��׵ĵ���Ϊ�� ',updttrdlist,' ,һ��������'];
    fprintf(logid,'%s\n\r',msg);
    fclose(logid);
    display(msg);
    
else  % ���޳ֲֵ�����£�Ӧ�ô��ն��ļ���������ļ��и��ƽ�����
    dayfiles=ls(dirdaily);
    [num,~]=size(dayfiles);
     % ����ļ��Ƿ�Ψһ
    if num>3 
        msg=['��ǰ�ն��ļ������� ',num2str(num-2),' ���ļ���Ӧֻ����Ψһ����µ��ļ�����'];
        logupdt_erroutpt(logid,msg);  
    end
    % ����ļ����Ƿ�Ϊ��
    daytrdlist=dayfiles(end,:);
    if strcmp(strrep(daytrdlist,' ',''),'..')  
        msg='�ն��ļ���Ϊ�գ�����';
        logupdt_erroutpt(logid,msg);
    end
    % ����ǰ������Ƿ���ڵ��ӷŴ��Ӧ����
    listdate=daytrdlist(end-11:end-4);
    listname=daytrdlist(1:end-12);
    if ~strcmp(strategy,listname) 
        msg=['�ն��ļ����У����Ӳ��Դ���ӦΪ ' ,strategy,' ��ǰΪ ',listname,' ������'];
        logupdt_erroutpt(logid,msg);
    end      
    % ����ǰ����鸴�Ƶ�������,�����������ղ�ͬ�򱨴�
    if ~strcmp(todaydt,listdate) 
        msg=['�˴��ύ�������ڣ� ',listdate,',�뵱ǰ���ڲ�ͬ�����飡����'];
        logupdt_erroutpt(logid,msg);
    end
    % ���ƿ�ʼǰ������ո����ļ���,ɾ������ CSV �ļ�
    [rmstatus,rmmsg]=system(['del ',dirupdate,'\*.csv']);
    if rmstatus~=0
        msg=['�����ļ������ʧ�ܣ�����ԭ�� ' rmmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg='�����ļ�������ɹ�����������';
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        display(msg);
    end   
    % ��������ʼ�����ļ�
    [cpstatus,cpmsg]=system(['xcopy ',dirdaily,' ',dirupdate ' /Y/S']);
    if cpstatus ~=0
        msg=['����ʧ�ܣ�����ԭ��: ' cpmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg=['���Ƴɹ�����ǰ�����ļ����е�������Ϊ ', listdate];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end    
    fclose(logid);
end