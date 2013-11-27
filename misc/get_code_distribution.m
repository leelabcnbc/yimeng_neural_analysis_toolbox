code_length = length(NEV_code{1});

code_distribution = cell(code_length,1);



for i = 1:length(NEV_code)
    next_code = NEV_code{i};
    
    for j = 1:code_length
        if ~ismember(next_code(j), code_distribution{j})
            code_distribution{j}(end+1) = next_code(j);
        end
    end
    
end