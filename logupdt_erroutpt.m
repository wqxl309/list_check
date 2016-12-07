function[]=logupdt_erroutpt(fid,msg)        
fprintf(fid,'%s\n',msg);
fprintf(fid,'\n');
fclose(fid);
error(msg);