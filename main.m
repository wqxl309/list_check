clear;
clc;
%%

% statusdir='D:\IFICIH_CTP\Release\cwstate\cwstate.txt';
% dirdaily='C:\Users\zhoufz\Desktop\�ն��ļ���';
% dirupdate='C:\Users\zhoufz\Desktop\�����ļ���';
statusdir='cwstate.txt';
logdir='.\log.txt';
buylstdir='\\ACERPC\tradelist\';
sellstdir='\\ACERPC\updtlist\';
dirupdate='.\�����ļ���\';
strategy='BQ2ICLong';
listcheck_update_v3(statusdir,logdir,buylstdir,sellstdir,dirupdate,strategy);
%exit;  