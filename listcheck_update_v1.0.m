function[]=listcheck_update_v1.0(statusdir,dirdaily,dirupdate,strategy)
%
% dirdaily Ϊ�洢ÿ�ո��µ���
% dirupdate Ϊ�洢ʵ�ʽ��׵���
% strategy Ϊ�������ƣ�Ӧ�뵥�����ڼ�Ĳ�����ͬ����tradeIC,tradeICLongOnly
%
% ���˳��
%   �гֲ�������������ļ���
%       �����ļ������ļ��Ƿ�Ψһ
%       �����ļ����Ƿ�Ϊ��
%       �����ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ
%       �����ļ����е��������Ƿ�Ϊ�ϴν������ڣ�������ȡ��cwstate
%   �޳ֲ����������ն��ļ���
%       �ն��ļ������ļ��Ƿ�Ψһ
%       �ն��ļ����Ƿ�Ϊ��
%       �ն��ļ����е��Ӳ����Ƿ��뵱ǰǰ������ͬ
%       �ն��ļ����е��������뵱�������Ƿ���ͬ
%       ������ȷ��׼�����и��ƣ�
%            ����ǰ����ɾ�������ļ����������ļ������ɾ���Ƿ�ɹ���
%            ��ɾ���ɹ����ƣ���鸴���Ƿ�ɹ�
%
% ����������־ log.txt

logid=fopen('log.txt','a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'\n\r');

cwstate=importdata(statusdir);
%������ȫΪ0����������

currentstate=cwstate(1);
lasttrddate=cwstate(end); 

if currentstate ~= 0  %���гֲֵ�����£������ļ�����Ӧ���潻�׵��յĵ���
    updtfiles=ls(dirupdate);
    [num,~]=size(updtfiles);
    if num>3  % ����ļ��Ƿ�Ψһ
        msg=['��ǰ�����ļ������� ',num2str(num-2),' ���ļ���Ӧֻ����Ψһ����µ��ļ�����'];
        logupdt_erroutpt(logid,msg);
    end
    updttrdlist=updtfiles(end,:);
    if strcmp(strrep(updttrdlist,' ',''),'..')   % ����ļ����Ƿ�Ϊ��
        msg='�����ļ���Ϊ�գ�����';
        logupdt_erroutpt(logid,msg);  
    end
    len=length(updttrdlist);
    listdate=updttrdlist(len-11:len-4);
    listname=updttrdlist(1:len-12);
    if ~strcmp(strategy,listname) % ����Ƿ���ڵ��ӷŴ���Ӧ����
        msg=['�����ļ����У����Ӳ��Դ���ӦΪ ' ,strategy,' ����ǰΪ ',listname,' ������'];      
        logupdt_erroutpt(logid,msg);  
    end
    if str2double(listdate)~=lasttrddate  % ����Ƿ���ڵ������ڴ���
        msg=['�����ļ����У��������ڴ���ӦΪ ', num2str(lasttrddate),' ��ǰΪ ',listdate,' ������'];
        logupdt_erroutpt(logid,msg);
    end    
    msg=['��ǰ�����ļ��������ϴν��׵ĵ��ӣ� ',updttrdlist,' ,���踴�ƣ�'];
    fprintf(logid,'%s\n\r',msg);
    fclose(logid);
    display(msg);
else  % ���޳ֲֵ�����£������ļ�����ӦΪ�������µĵ���
    dayfiles=ls(dirdaily);
    [num,~]=size(dayfiles);
    if num>3  % ����ļ��Ƿ�Ψһ
        msg=['��ǰ�ն��ļ������� ',num2str(num-2),' ���ļ���Ӧֻ����Ψһ����µ��ļ�����'];
        logupdt_erroutpt(logid,msg);  
    end
    daytrdlist=dayfiles(end,:);
    if strcmp(strrep(daytrdlist,' ',''),'..')  % ����ļ����Ƿ�Ϊ��
        msg='�ն��ļ���Ϊ�գ�����';
        logupdt_erroutpt(logid,msg);
    end
    len=length(daytrdlist);
    listdate=daytrdlist(len-11:len-4);
    listname=daytrdlist(1:len-12);
    if ~strcmp(strategy,listname) % ����ǰ������Ƿ���ڵ��ӷŴ���Ӧ����
        msg=['�ն��ļ����У����Ӳ��Դ���ӦΪ ' ,strategy,' ��ǰΪ ',listname,' ������'];
        logupdt_erroutpt(logid,msg);
    end      
    if ~strcmp(datestr(today(),'yyyymmdd'),listdate) % ����ǰ����鸴�Ƶ�������,�����������ղ�ͬ�򱨴�
        msg=['�˴��ύ�������ڣ� ',listdate,',�뵱ǰ���ڲ�ͬ�����飡����'];
        logupdt_erroutpt(logid,msg);
    end
    % ���ƿ�ʼǰ������ո����ļ���,ɾ������csv�ļ�
    [rmstatus,~]=system(['del ',dirupdate,'\*.csv']);
    if rmstatus~=0
        msg='ɾ��ʧ�ܣ����飡����';
        logupdt_erroutpt(logid,msg);
    else
        msg='�����ļ�������ɹ�';
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        display(msg);
    end   
    % ��������ʼ�����ļ�
    [cpstatus,~]=system(['xcopy ',dirdaily,' ',dirupdate ' /Y/S']);
    if cpstatus ~=0
        msg='����ʧ�ܣ����飡����';
        logupdt_erroutpt(logid,msg);
    else
        msg=['���Ƴɹ�����ǰ�����ļ����е�������Ϊ ', listdate];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        fclose(logid);
        display(msg);
    end    
end