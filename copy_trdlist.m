function[err]=copy_trdlist(logid,fromdir,todir,todirname,cleandir,fileprefix,strategy,filedate,filetype,filenum,ignore)
% ���ƽ��׵��ӣ�
    % ѡ������� �� ����ǰ�Ƿ����Ŀ���ļ��� �Ҳ����ļ��Ƿ��������� �Ƿ����ļ������ļ���Ŀ
    % ѡ������ �� ������ɺ�Ŀ���ļ������ļ���Ŀ
    % ���� 0 ��ʾ���Ƴɹ���1 ��ʾû�и��ƣ���������򵯳����󴰿�
    if cleandir   % ���ƿ�ʼǰ���Ƿ����Ŀ���ļ���
        [rmstatus,rmmsg]=system(['del ',todir,'\*',filetype]);
        if rmstatus~=0
            msg=[todirname ' ���ʧ�ܣ�����ԭ�� ' rmmsg];
            logupdt_erroutpt(logid,msg);
            display(msg);
        else
            msg=[todirname ' ��ճɹ�,��������'];
            fprintf(logid,'%s\n\r',msg);
            fprintf(logid,'\n\r');
            display(msg);
        end        
    end
    
    % �����������ʼ��ֵ �ļ����ṹ ǰ׺+��������+����+�ļ�����
    filename=[fileprefix,strategy,filedate,filetype];
    [cpstatus,cpmsg]=system(['copy ',fromdir, filename ,' ', todir]);
    if cpstatus ~=0
        if strcmp(cpmsg(1:end-2),'ϵͳ�Ҳ���ָ�����ļ�')
            if ignore  % û�ҵ��ļ���ֱ�ӽ���
                msg=['���� ', filename, ' �����ڣ�����û�н��и���'];
                display(msg)
                err=1;
                return
            else
                msg=['���� ', filename, ' �����ڣ����飡'];
                [~,~]=system(['del ',todir,'\*',filetype]);   % �κ�һ�����Ӹ���ʧ�ܶ�������ļ���
                logupdt_erroutpt(logid,msg);
                display(msg);
            end
        else
            msg=['���Ӹ���ʧ�ܣ�����ԭ��' cpmsg];
            logupdt_erroutpt(logid,msg);
            display(msg);
        end
    else
        msg=['���� ',filename,' �ɹ����Ƶ� ',todirname];
        fprintf(logid,'%s\n\r',msg);
        fprintf(logid,'\n\r');
        fprintf(logid,'\n\r');
        display(msg);
    end
    
    % ������ɣ����Ŀ���ļ������ļ���Ŀ�Ƿ񸴺�Ҫ��
    files=ls(todir);
    [num,~]=size(files);
    if num-2~=filenum 
        msg=['��ǰ ',filename,' ���� ',num2str(num-2),'���ļ���Ӧ�ð��� ',num2str(filenum),'���ļ�������'];
        logupdt_erroutpt(logid,msg);  
        dislplay(msg);
    else
        msg=['��ǰ ',filename,' ���� ',num2str(num-2),'���ļ�������Ҫ�� ']; 
        display(msg);
    end
    err=0;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    