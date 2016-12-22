function[]=logupdt_erroutpt(fid,msg)        
fprintf(fid,'%s\n',msg);
fprintf(fid,'\n\r');
fprintf(fid,'\n\r');
fclose(fid);
error(msg);