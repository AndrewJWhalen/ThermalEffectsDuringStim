% calculates the ion concentration
function profile_t_conc = concentration(profile_t)
    

    Vol_int = profile_t(5,:);
    Vol_ext = extvolume(profile_t);
    profile_t_conc = profile_t;
    
    %Ion unit=mol
    

    profile_t_conc(6,:) = profile_t(6,:)./Vol_ext;   %NKo
    profile_t_conc(8,:) = profile_t(8,:)./Vol_ext;   %NNao
    profile_t_conc(10,:) = profile_t(10,:)./Vol_ext;   %NClo
    
    profile_t_conc(7,:) = profile_t(7,:)./Vol_int;
    profile_t_conc(9,:) = profile_t(9,:)./Vol_int;
    profile_t_conc(11,:) = profile_t(11,:)./Vol_int;
end
