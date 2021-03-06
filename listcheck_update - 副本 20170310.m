function[]=listcheck_update(statusdir,dirdaily,dirupdate,strategy)
%
% dirdaily 为存储每日更新单子
% dirupdate 为存储实际交易单子
% strategy 为策略名称，应与单子日期间的部分相同，如tradeIC,tradeICLongOnly
%
% 检查顺序：
%   先复制当日收到的交易单子到 日度文件夹，无论是否有持仓
%       复制前先删除所有文件，检查是否删除成功
%       若删除成功则复制，检查复制是否成功，且复制的单子的日期为交易日 当日
%   有持仓情况：检查更新文件夹
%       更新文件夹中文件是否唯一
%       更新文件夹是否为空
%       检查单子日期时间，判断是否为改过的单子 ，若改过则策略名称应包含 m_   
%       更新文件夹中单子策略是否与当前前策略相同
%       更新文件夹中单子日期是否为上次交易日期，该日期取自cwstate
%   无持仓情况：检查日度文件夹
%       日度文件夹中文件是否唯一
%       日度文件夹是否为空
%       日度文件夹中单子策略是否与当前前策略相同
%       日度文件夹中单子日期与当日日期是否相同
%       若均正确则准备进行复制：
%            复制前首先删除更新文件夹中所有文件，检查删除是否成功；
%            若删除成功则复制，检查复制是否成功
%       记录复制的文件夹对应时间
%
% 结果输出至日志 log.txt

logid=fopen('D:\挂单检查\log.txt','a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'\n\r');

cwstate=importdata(statusdir);
%出场后全为0，包括日期


%%%%%%%%%%%%%%%%%%%%%%%%%  复制单子至日度文件夹 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 复制开始前，先清空日度文件夹,删除所有csv文件
[rmstatus,rmmsg]=system(['del ',dirdaily,'\*.csv']);
if rmstatus~=0
    msg=['日度文件夹清空失败，错误原因： ' rmmsg];
    logupdt_erroutpt(logid,msg);
else
    msg='日度文件夹清除成功,即将复制';
    fprintf(logid,'%s\n\r',msg);
    fprintf(logid,'\n\r');
    display(msg);
end
% 正常，开始复制文件
todaydt=datestr(today(),'yyyymmdd');
[cpstatus,cpmsg]=system(['copy \\ACERPC\tradelist\',strategy ,todaydt, '.csv ',dirdaily]);
if cpstatus ~=0
    msg=['复制失败，错误原因：' cpmsg];
    logupdt_erroutpt(logid,msg);
else
    msg=['复制成功，当前日度文件夹中单子日期为 ', todaydt];
    fprintf(logid,'%s\n\r',msg);
    fprintf(logid,'\n\r');
    fprintf(logid,'\n\r');
    display(msg);
end


currentstate=cwstate(1);
lasttrddate=cwstate(end); 

if currentstate ~= 0  %在有持仓的情况下，更新文件夹中应保存交易当日的单子
    updtfiles=ls(dirupdate);
    [num,~]=size(updtfiles);
    if num>3  % 检查文件是否唯一
        msg=['当前更新文件夹中有 ',num2str(num-2),' 个文件，应只包含唯一需更新的文件！！'];
        logupdt_erroutpt(logid,msg);
    end
    updttrdlist=updtfiles(end,:);
    if strcmp(strrep(updttrdlist,' ',''),'..')   % 检查文件夹是否为空
        msg='更新文件夹为空！！！';
        logupdt_erroutpt(logid,msg);  
    end
    listdate=updttrdlist(end-11:end-4);
    listname=updttrdlist(1:end-12);
    % 检查当前更新文件夹中的文件时间，如果与首次复制时不同则文件名应为 m_ + strategy
    % 此时已通过上述检验，确定文件夹中文件存在且唯一
    load('lastupdt');
    [lsstatus,lsinfo]=system(['dir ' dirupdate]);
    if lsstatus~=0   % 检查提取列表信息是否正确
        msg='更新文件夹提取列表信息错误';
        logupdt_erroutpt(logid,msg);  
    end
    temp =strsplit(lsinfo,'\n');
    temp2=strsplit(temp{6},' ');
    currentdt=[temp2{1} ' ' temp2{2}];
    if ~strcmp(currentdt,lastupdt)
        strategy=[ 'm_' strategy];
    end    
    if ~strcmp(strategy,listname) % 检测是否存在单子放错对应策略
        msg=['更新文件夹中，单子策略错误，应为 ' ,strategy,' ，当前为 ',listname,' ！！！'];      
        logupdt_erroutpt(logid,msg);  
    end
    if str2double(listdate)~=lasttrddate  % 检测是否存在单子日期错误
        msg=['更新文件夹中，单子日期错误，应为 ', num2str(lasttrddate),' 当前为 ',listdate,' ！！！'];
        logupdt_erroutpt(logid,msg);
    end    
    msg=['当前更新文件夹中有上次交易的单子， ',updttrdlist,' ,无需复制！'];
    fprintf(logid,'%s\n\r',msg);
    fclose(logid);
    display(msg);
else  % 在无持仓的情况下，更新文件夹中应为当日最新的单子
    dayfiles=ls(dirdaily);
    [num,~]=size(dayfiles);
    if num>3  % 检查文件是否唯一
        msg=['当前日度文件夹中有 ',num2str(num-2),' 个文件，应只包含唯一需更新的文件！！'];
        logupdt_erroutpt(logid,msg);  
    end
    daytrdlist=dayfiles(end,:);
    if strcmp(strrep(daytrdlist,' ',''),'..')  % 检查文件夹是否为空
        msg='日度文件夹为空！！！';
        logupdt_erroutpt(logid,msg);
    end
    listdate=daytrdlist(end-11:end-4);
    listname=daytrdlist(1:end-12);
    if ~strcmp(strategy,listname) % 复制前，检测是否存在单子放错对应策略
        msg=['日度文件夹中，单子策略错误应为 ' ,strategy,' 当前为 ',listname,' ！！！'];
        logupdt_erroutpt(logid,msg);
    end      
    if ~strcmp(datestr(today(),'yyyymmdd'),listdate) % 复制前，检查复制单子日期,如果日期与今日不同则报错
        msg=['此次提交单子日期： ',listdate,',与当前日期不同，请检查！！！'];
        logupdt_erroutpt(logid,msg);
    end
    % 复制开始前，先清空更新文件夹,删除所有csv文件
    [rmstatus,rmmsg]=system(['del ',dirupdate,'\*.csv']);
    if rmstatus~=0
        msg=['更新文件夹清空失败，错误原因： ' rmmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg='更新文件夹清除成功，即将复制';
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        display(msg);
    end   
    % 正常，开始复制文件
    [cpstatus,cpmsg]=system(['xcopy ',dirdaily,' ',dirupdate ' /Y/S']);
    if cpstatus ~=0
        msg=['复制失败，错误原因: ' cpmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg=['复制成功，当前更新文件夹中单子日期为 ', listdate];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end    
    % 记录复制后，更新文件夹内单子时间    
    [lsstatus,lsinfo]=system(['dir ' dirupdate]);
    if lsstatus~=0   % 检查提取列表信息是否正确
        msg='日度文件夹提取列表信息错误';
        logupdt_erroutpt(logid,msg);
    end
    temp =strsplit(lsinfo,'\n');
    temp2=strsplit(temp{6},' ');
    fclose(logid);
    lastupdt=[temp2{1} ' ' temp2{2}];
    save('lastupdt','lastupdt');
end

