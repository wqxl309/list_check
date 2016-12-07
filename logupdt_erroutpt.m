function[]=logupdt_erroutpt(fid,msg)        
fprintf(fid,'%s\n',msg);
fprintf(logid,'\n\r');
fprintf(logid,'\n\r');
fclose(fid);
error(msg);