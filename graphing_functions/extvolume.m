% calculates the extracellular volume
function Vol_ext = extvolume(profile_t)
    
    Vol = 1.4368e-15;
    beta0 = 7;
    Vol_int = profile_t(5,:);
    Vol_ext = (1+1/beta0)*Vol-Vol_int;
    
end