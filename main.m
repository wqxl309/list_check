clear;
clc;
%%

% statusdir='D:\IFICIH_CTP\Release\cwstate\cwstate.txt';
% dirdaily='C:\Users\zhoufz\Desktop\日度文件夹';
% dirupdate='C:\Users\zhoufz\Desktop\更新文件夹';
statusdir='cwstate.txt';
logdir='.\log.txt';
buylstdir='\\ACERPC\tradelist\';
sellstdir='\\ACERPC\updtlist\';
dirupdate='.\更新文件夹\';
strategy='BQ2ICLong';
listcheck_update_v3(statusdir,logdir,buylstdir,sellstdir,dirupdate,strategy);
%exit;  