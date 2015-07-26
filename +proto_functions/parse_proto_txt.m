function result = parse_proto_txt(fileName, protoClass)
% PARSE_PROTO_TXT parse a text based protobuf message. 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 21-Jul-2015 12:44:39 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : parse_proto_txt.m 

% now, it's only responsible for decoding the trial template.

% if nargin < 2 || isempty(protoClass)
%     protoClass = ...
%         'com.leelab.monkey_exp.RewardedTrialTemplateProtos$RewardedTrialTemplate';
% end

builder = javaMethod('newBuilder',protoClass);

javaMethod('merge','com.google.protobuf.TextFormat', ...
    java.io.InputStreamReader(java.io.FileInputStream(fileName)),builder)

result = builder.build();

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [parse_proto_txt.m] ======  
