function params = parse_proto_bin(fileName, protoClass)
% PARSE_PROTO_BIN parse a binary protobuf message. 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 21-Jul-2015 12:44:39 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : parse_proto_txt.m 

params = ...
    javaMethod('parseFrom',protoClass,java.io.FileInputStream(fileName));

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [parse_proto_txt.m] ======  
