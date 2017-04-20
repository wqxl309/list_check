function[]=listcheck_update_v3(statusdir,logdir,buylstdir,sellstdir,dirupdate,strategy)
%
% dirdaily 为存储每日更新单子
% dirupdate 为存储实际交易单子
% strategy 为策略名称，应与单子日期间的部分相同，如tradeIC, tradeICLongOnly
%
% 检查顺序：

%   满仓情况：必须复制至 更新文件夹
%       复制当日卖出单子至更新文件夹
%       更新文件夹中文件应该唯一
%       更新文件夹中单子策略是否与当前前策略相同，策略名称应包含 m_
%       更新文件夹中单子日期是否为当前交易日

%   空仓情况：必须复制至 更新文件夹
%       复制当日买入单子至日度文件夹
%       日度文件夹中文件是否唯一
%       日度文件夹中单子策略是否与当前前策略相同
%       日度文件夹中单子日期与当日日期是否相同

%   部分仓位情况：
%       当日新发买单应该复制到日度文件夹
%       当日买单应复制到更新文件夹

% 结果输出至日志 log.txt

logid=fopen(logdir,'a');
msg=['Update Date : ',datestr(now()),' Strategy Name : ',strategy];
msg2='当前更新程序版本 V3.0';
fprintf(logid,'%s\n\r',msg);
fprintf(logid,'%s\n\r',msg2);
fprintf(logid,'\n\r');
display(msg);
display(msg2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% 检查当前仓位状态 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cwstate=importdata(statusdir);
[levels,~]=size(cwstate);
currentstate=sum(cwstate(:,1)~=0);
%出场后全为0，包括日期

todaydt=datestr(today(),'yyyymmdd');
updtname='更新文件夹';
sellpfx='m_';
sellftp='.csv';
buypfx='';
buyftp='.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if currentstate == levels  %在满仓的情况下
    %%%%%%%%%% 复制制作的当日卖单至更新文件夹，日期应为当前交易日，策略名称前应有m_,更新文件夹中文件应唯一  %%%%%%%%
    msg=['目前满仓：应复制唯一卖单 ' sellpfx strategy todaydt sellftp '至更新文件夹'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errsell=copy_trdlist(logid,sellstdir,dirupdate,updtname,true,sellpfx,strategy,todaydt,sellftp,1,false);
    if errsell==0
        display('卖单复制成功！');
    end
    
elseif currentstate==0  % 在无持仓的情况下，
    %%%%%%%%%%%%%%%% 复制发送的当日买单至更新文件夹，单子日期应为当前日期，单子应唯一 %%%%%%%%%%%%%
    msg=['目前空仓：应复制唯一买单 ' buypfx strategy todaydt buyftp '至更新文件夹'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errbuy=copy_trdlist(logid,buylstdir,dirupdate,updtname,true,buypfx,strategy,todaydt,buyftp,1,false);
    if errbuy==0
        display('买单复制成功！');
    end

else   % 在部分持仓的情况下
    msg=['目前持有 ' num2str(currentstate) ' 档，共' num2str(levels) '档，需要将买单和卖单 都复制到更新文件夹'];
    fprintf(logid,'%s\n\r',msg);
    display(msg);
    errsell=copy_trdlist(logid,sellstdir,dirupdate,updtname,true,sellpfx,strategy,todaydt,sellftp,1,false);
    errbuy=copy_trdlist(logid,buylstdir,dirupdate,updtname,false,buypfx,strategy,todaydt,buyftp,2,false);
    if errbuy==0 && errsell==0
        display('买卖单复制成功！');
    end
    
end
fclose(logid);







