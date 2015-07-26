function write_proto_txt(protoObj, filename)
% WRITE_PROTO_TXT ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 26-Jul-2015 15:46:18 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : write_proto_txt.m 

stringToWrite = char(protoObj.toString());
fid = fopen(filename,'wt'); % text mode.
fprintf(fid,'%s',stringToWrite);
fclose(fid);

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [write_proto_txt.m] ======  
