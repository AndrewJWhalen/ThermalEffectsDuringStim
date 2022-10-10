% this will take in either a number then return string of what variable it
% is (i.e. 5->Voli),
% or it will take the string and return the index

function output = um_var(x)

    if isnumeric(x)
        switch x
            case 1
                output = 'V';
            case 2
                output = 'm';
            case 3
                output = 'n';
            case 4
                output = 'h';
            case 5
                output = 'Voli';
            case 6
                output = 'NKo';
            case 7
                output = 'NKi';
            case 8
                output = 'NNao';
            case 9
                output = 'NNai';
            case 10
                output = 'NClo';
            case 11
                output = 'NCli';
            case 12
                output = 'NO';
            otherwise
                error('UM variable number is not valid')
        end
        
    elseif ischar(x)
        switch lower(x)
            case 'v'
                output = 1;
            case 'm'
                output = 2;
            case 'n'
                output = 3;
            case 'h'
                output = 4;
            case 'voli'
                output = 5;
            case 'ko'
                output = 6;
            case 'ki'
                output = 7;
            case 'nao'
                output = 8;
            case 'nai'
                output = 9;
            case 'clo'
                output = 10;
            case 'cli'
                output = 11;
            case 'o'
                output = 12;
            otherwise
                error('UM variable name is not valid')
        end
        
    else
        error('um_var error')
    end
        

end

