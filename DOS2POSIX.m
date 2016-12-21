function[posix_dir]=DOS2POSIX(dos_dir)
dircomps=strsplit(dos_dir,'\');
posix_dir='/cygdrive/';
for dumi=1:length(dircomps)
    if dumi==1
        posix_dir=[posix_dir,dircomps{dumi}(1),'/'];
    else
        posix_dir=[posix_dir,dircomps{dumi},'/'];
    end
end