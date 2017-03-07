function[]=listcheck_update_v2(statusdir,dirdaily,dirupdate,strategy)
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
%       �����ļ������ļ��Ƿ�Ψһ
%       �����ļ����Ƿ�Ϊ��
%       ��鵥������ʱ�䣬�ж��Ƿ�Ϊ�Ĺ��ĵ��� �����Ĺ����������Ӧ���� m_   
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
%       ��¼���Ƶ��ļ��ж�Ӧʱ��
%
% ����������־ log.txt

logid=fopen('D:\�ҵ����\log.txt','a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'\n\r');

cwstate=importdata(statusdir);
%������ȫΪ0����������


%%%%%%%%%%%%%%%%%%%%%%%%%  ���Ƶ������ն��ļ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ƿ�ʼǰ��������ն��ļ���,ɾ������csv�ļ�
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


currentstate=cwstate(end,1);

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
    % ��鵱ǰ�����ļ����е��ļ�ʱ�䣬������״θ���ʱ��ͬ���ļ���ӦΪ m_ + strategy
    % ��ʱ��ͨ���������飬ȷ���ļ������ļ�������Ψһ
    load('lastupdt');
    [lsstatus,lsinfo]=system(['dir ' dirupdate]);
    if lsstatus~=0   % �����ȡ�б���Ϣ�Ƿ���ȷ
        msg='�����ļ�����ȡ�б���Ϣ����';
        logupdt_erroutpt(logid,msg);  
    end
    temp =strsplit(lsinfo,'\n');
    temp2=strsplit(temp{6},' ');
    currentdt=[temp2{1} ' ' temp2{2}];
    if ~strcmp(currentdt,lastupdt)
        strategy=[ 'm_' strategy];
    end    
    if ~strcmp(strategy,listname) % ����Ƿ���ڵ��ӷŴ��Ӧ����
        msg=['�����ļ����У����Ӳ��Դ���ӦΪ ' ,strategy,' ����ǰΪ ',listname,' ������'];      
        logupdt_erroutpt(logid,msg);  
    end
    currentdate=datestr(today(),'yyyymmdd');
    if str2double(listdate)~=str2double(currentdate)  % ����Ƿ���ڵ������ڴ���
        msg=['�����ļ����У��������ڴ���ӦΪ ', currentdate,' ��ǰΪ ',listdate,' ������'];
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
    if ~strcmp(strategy,listname) % ����ǰ������Ƿ���ڵ��ӷŴ��Ӧ����
        msg=['�ն��ļ����У����Ӳ��Դ���ӦΪ ' ,strategy,' ��ǰΪ ',listname,' ������'];
        logupdt_erroutpt(logid,msg);
    end      
    if ~strcmp(datestr(today(),'yyyymmdd'),listdate) % ����ǰ����鸴�Ƶ�������,�����������ղ�ͬ�򱨴�
        msg=['�˴��ύ�������ڣ� ',listdate,',�뵱ǰ���ڲ�ͬ�����飡����'];
        logupdt_erroutpt(logid,msg);
    end
    % ���ƿ�ʼǰ������ո����ļ���,ɾ������csv�ļ�
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
    % ��¼���ƺ󣬸����ļ����ڵ���ʱ��    
    [lsstatus,lsinfo]=system(['dir ' dirupdate]);
    if lsstatus~=0   % �����ȡ�б���Ϣ�Ƿ���ȷ
        msg='�ն��ļ�����ȡ�б���Ϣ����';
        logupdt_erroutpt(logid,msg);
    end
    temp =strsplit(lsinfo,'\n');
    temp2=strsplit(temp{6},' ');
    fclose(logid);
    lastupdt=[temp2{1} ' ' temp2{2}];
    save('lastupdt','lastupdt');
end