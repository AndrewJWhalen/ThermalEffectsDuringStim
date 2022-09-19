% this will take in either a number then return string of what variable it
% is (i.e. 5->Voli),
% or it will take the string and return the index

function output = um_init_var(x)

    if isnumeric(x)
        switch x
            case 1
                output = 'Pump';
            case 2
                output = 'dn/dt';
            case 3
                output = 'dm/dt';
            case 4
                output = 'dh/dt';
            case 5
                output = 'GK';
            case 6
                output = 'GNa';
            case 7
                output = 'Kleak';
            case 8
                output = 'Naleak';
            case 9
                output = 'Clleak';
            case 10
                output = 'O2 diffusion';
            case 11
                output = 'Temperature';
            case 12
                output = 'NKCC1';
            case 13
                output = 'KCC2';
            otherwise
                error('UM variable number is not valid')
        end
        
    elseif ischar(x)
        switch lower(x)
            case 'pump'
                output = 1;
            case 'n'
                output = 2;
            case 'm'
                output = 3;
            case 'h'
                output = 4;
            case 'gk'
                output = 5;
            case 'gna'
                output = 6;
            case 'kleak'
                output = 7;
            case 'naleak'
                output = 8;
            case 'clleak'
                output = 9;
            case 'o2d'
                output = 10;
            case 'temp'
                output = 11;
            case 'nkcc1'
                output = 12;
            case 'kcc2'
                output = 13;
            otherwise
                error('UM variable name is not valid')
        end
        
    else
        error('um_var error')
    end
        

end

