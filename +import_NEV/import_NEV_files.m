function [CDTTables] = import_NEV_files(NEV_file_list, import_params, CTX_file_list)
% IMPORT_NEV_FILES convert a batch of NEV files into CDT tables.
%  
%   return tables, waiting to be written back to disk. 
%
%   import_params is a Java object of ImportParams. I do this rather than
%   using prototxt because we can easily switch to binary format if using
%   such interface.
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 23-Jul-2015 09:16:06 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : import_NEV_files.m 
import import_NEV.import_NEV_file

NEV_file_list = NEV_file_list(:);
if nargin < 3 || isempty(CTX_file_list)
    CTX_file_list = cell(numel(NEV_file_list),1); % empty CTX.
end

% call import_NEV_file on each NEV_file in the list, passing import_params.
CDTTables = cellfun(@(x,y) import_NEV_file(x, import_params, y), NEV_file_list, CTX_file_list);

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [import_NEV_files.m] ======  
