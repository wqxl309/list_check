function[err]=copy_trdlist(logid,fromdir,todir,todirname,cleandir,fileprefix,strategy,filedate,filetype,filenum,ignore)
% 复制交易单子：
    % 选择操作项 ： 复制前是否清空目标文件夹 找不到文件是否跳过错误 是否检查文件夹中文件数目
    % 选择检查项 ： 复制完成后，目标文件夹中文件数目
    % 返回 0 表示复制成功，1 表示没有复制，其他情况则弹出错误窗口
    if cleandir   % 复制开始前，是否清除目标文件夹
        [rmstatus,rmmsg]=system(['del ',todir,'\*',filetype]);
        if rmstatus~=0
            msg=[todirname ' 清空失败，错误原因： ' rmmsg];
            logupdt_erroutpt(logid,msg);
            display(msg);
        else
            msg=[todirname ' 清空成功,即将复制'];
            fprintf(logid,'%s\n\r',msg);
            fprintf(logid,'\n\r');
            display(msg);
        end        
    end
    
    % 清空正常，开始赋值 文件名结构 前缀+策略名称+日期+文件类型
    filename=[fileprefix,strategy,filedate,filetype];
    [cpstatus,cpmsg]=system(['copy ',fromdir, filename ,' ', todir]);
    if cpstatus ~=0
        if strcmp(cpmsg(1:end-2),'系统找不到指定的文件')
            if ignore  % 没找到文件，直接结束
                msg=['单子 ', filename, ' 不存在，程序没有进行复制'];
                display(msg)
                err=1;
                return
            else
                msg=['单子 ', filename, ' 不存在，请检查！'];
                [~,~]=system(['del ',todir,'\*',filetype]);   % 任何一个单子复制失败都将清除文件夹
                logupdt_erroutpt(logid,msg);
                display(msg);
            end
        else
            msg=['单子复制失败，错误原因：' cpmsg];
            logupdt_erroutpt(logid,msg);
            display(msg);
        end
    else
        msg=['单子 ',filename,' 成功复制到 ',todirname];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end
    
    % 复制完成，检查目标文件夹中文件数目是否复核要求
    files=ls(todir);
    [num,~]=size(files);
    if num-2~=filenum 
        msg=['当前 ',filename,' 中有 ',num2str(num-2),'个文件，应该包含 ',num2str(filenum),'个文件，请检查'];
        logupdt_erroutpt(logid,msg);  
        dislplay(msg);
    else
        msg=['当前 ',filename,' 中有 ',num2str(num-2),'个文件，符合要求 ']; 
        display(msg);
    end
    err=0;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    