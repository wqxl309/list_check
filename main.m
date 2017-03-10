clear;
clc;
%%

% statusdir='D:\IFICIH_CTP\Release\cwstate\cwstate.txt';
% dirdaily='C:\Users\zhoufz\Desktop\日度文件夹';
% dirupdate='C:\Users\zhoufz\Desktop\更新文件夹';
statusdir='cwstate.txt';
logdir='D:\Works\挂单检查\log.txt';
dirdaily='D:\Works\挂单检查\日度文件夹';
dirupdate='D:\Works\挂单检查\更新文件夹';
strategy='BQ1ICLong';
listcheck_update(statusdir,logdir,dirdaily,dirupdate,strategy);
%exit;  