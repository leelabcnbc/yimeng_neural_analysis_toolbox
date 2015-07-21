function initialize_java_path()
% INITIALIZE_JAVA_PATH ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 06-Jul-2015 20:46:02 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : initialize_java_path.m 



% change the current directory to the parent directory of this file...
[baseDir, ~, ~] = fileparts(mfilename('fullpath'));
cd(baseDir);
disp(baseDir);

% check if your version of MATLAB ships with a protobuf...
if any(~cellfun(@isempty,strfind(javaclasspath('-static'),'protobuf')))
    warning('your MATLAB maybe shipped with a protobuf!');
end

% add protobuf library. This won't work for MATLAB that ships with
% protobuf...
javaaddpath(fullfile(pwd,'3rdparty','protobuf-java-2.6.1.jar'));

% add protobuf classes
javaaddpath(fullfile(pwd,'proto_classes'));

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [initialize_java_path.m] ======  
