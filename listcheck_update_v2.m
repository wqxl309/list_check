function[]=listcheck_update_v2(statusdir,logdir,dirdaily,dirupdate,strategy)
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
%       复制当日卖出单子至更新文件夹
%       更新文件夹中文件是否唯一
%       更新文件夹是否为空
%       更新文件夹中单子策略是否与当前前策略相同，策略名称应包含 m_
%       更新文件夹中单子日期是否为当前交易日
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

logid=fopen(logdir,'a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'\n\r');

cwstate=importdata(statusdir);
%出场后全为0，包括日期


%%%%%%%%%%%%%%%%%%%%%%%%%  复制单子至日度文件夹 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 复制开始前，先清空日度文件夹,删除所有 CSV 文件
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%% 检查当前状态 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
currentstate=cwstate(end,1);

if currentstate ~= 0  %在有持仓的情况下
    %%%%%%%%%% 复制制作的当日卖单，日期应为当前交易日，策略名称前应有m_  %%%%%%%%
    % 复制开始前，先清空更新文件夹,删除 CSV 所有文件
    [rmstatus,rmmsg]=system(['del ',dirupdate,'\*.csv']);
    if rmstatus~=0
        msg=['更新文件夹清空失败，错误原因： ' rmmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg='更新文件夹清除成功,即将复制';
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        display(msg);
    end
    % 正常，开始复制 目前为 CSV 文件
    [cpstatus,cpmsg]=system(['copy \\ACERPC\updtlist\m_',strategy ,todaydt, '.csv ',dirupdate]);
    if cpstatus ~=0
        msg=['复制失败，错误原因：' cpmsg];
        logupdt_erroutpt(logid,msg);
    else
        msg=['复制成功，当前更新文件夹中单子日期为 ', todaydt];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end    
    %%%%%%% 复制完成后 检查更新文件夹中文件是否唯一 或 是否为空 %%%%%%%%
    updtfiles=ls(dirupdate);
    [num,~]=size(updtfiles);
    % 检查文件是否唯一
    if num>3  
        msg=['当前更新文件夹中有 ',num2str(num-2),' 个文件，应只包含唯一需更新的文件！！'];
        logupdt_erroutpt(logid,msg);
    end
    % 检查文件夹是否为空
    updttrdlist=updtfiles(end,:);
    if strcmp(strrep(updttrdlist,' ',''),'..')   
        msg='更新文件夹为空！！！';
        logupdt_erroutpt(logid,msg);  
    end
    %%%%%%%% 此时已通过上述检验，确定文件夹中文件存在且唯一，检查单子本身 %%%%%%%%
    listdate=updttrdlist(end-11:end-4);
    listname=updttrdlist(1:end-12);
    % 检查当前更新文件中文件名应为 m_ + strategy    
    if ~strcmp(['m_' strategy],listname) % 检测是否存在单子放错对应策略
        msg=['更新文件夹中，单子策略错误，应为 m_' ,strategy,' ，当前为 ',listname,' ！！！'];      
        logupdt_erroutpt(logid,msg);  
    end
    % 检测是否存在单子日期，应为当前日期
    % currentdate=datestr(today(),'yyyymmdd');
    if ~strcmp(listdate,todaydt) 
        msg=['更新文件夹中，单子日期错误，应为 ', todaydt,' 当前为 ',listdate,' ！！！'];
        logupdt_erroutpt(logid,msg);
    end        
    %%%%%%%%% 检查完成，更新正常！ %%%%%%%%%%%
    msg=['当前更新文件夹中的次交易的单子为： ',updttrdlist,' ,一切正常！'];
    fprintf(logid,'%s\n\r',msg);
    fclose(logid);
    display(msg);
    
else  % 在无持仓的情况下，应该从日度文件夹向更新文件夹复制今日买单
    dayfiles=ls(dirdaily);
    [num,~]=size(dayfiles);
     % 检查文件是否唯一
    if num>3 
        msg=['当前日度文件夹中有 ',num2str(num-2),' 个文件，应只包含唯一需更新的文件！！'];
        logupdt_erroutpt(logid,msg);  
    end
    % 检查文件夹是否为空
    daytrdlist=dayfiles(end,:);
    if strcmp(strrep(daytrdlist,' ',''),'..')  
        msg='日度文件夹为空！！！';
        logupdt_erroutpt(logid,msg);
    end
    % 复制前，检测是否存在单子放错对应策略
    listdate=daytrdlist(end-11:end-4);
    listname=daytrdlist(1:end-12);
    if ~strcmp(strategy,listname) 
        msg=['日度文件夹中，单子策略错误应为 ' ,strategy,' 当前为 ',listname,' ！！！'];
        logupdt_erroutpt(logid,msg);
    end      
    % 复制前，检查复制单子日期,如果日期与今日不同则报错
    if ~strcmp(todaydt,listdate) 
        msg=['此次提交单子日期： ',listdate,',与当前日期不同，请检查！！！'];
        logupdt_erroutpt(logid,msg);
    end
    % 复制开始前，先清空更新文件夹,删除所有 CSV 文件
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
    fclose(logid);
end