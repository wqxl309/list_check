function[]=logupdt_erroutpt(fid,msg)        
fprintf(fid,'%s\n',msg);
fprintf(logid,'\n\r');
fprintf(logid,'\n\r');
fclose(fid);
error(msg);

load handel;
p = audioplayer(y, Fs);
play(p, [1 (get(p, 'SampleRate') * 11)]);