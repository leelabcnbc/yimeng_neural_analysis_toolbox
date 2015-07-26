function write_proto_bin(protoObj, filename)
% WRITE_PROTO_BIN ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 26-Jul-2015 15:43:34 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : write_proto_bin.m 

javaMethod('writeTo',protoObj,java.io.FileOutputStream(filename));

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [write_proto_bin.m] ======  
