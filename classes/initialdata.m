classdef initialdata
    properties
        profile_0
        function_name
        function_path
        bath
        init
    end
    methods
        function [p,c] = cont(obj, tc, tstart, last, ss, dT)
            try
                addpath(obj.function_path)
            catch
            end
            [p,c] = obj.function_name(obj.profile_0, obj.bath, obj.init, obj.init, tc, tstart, last, ss,dT);
            try
                rmpath(obj.function_path)
            catch
            end
        end
        function obj = initialdata(profile_0, function_name, function_path, bath, init)
            obj.profile_0=profile_0;
            obj.function_name=function_name;
            obj.function_path=function_path;
            obj.bath=bath;
            obj.init=init;
        end
            
    end
end

    %% method to continue using same parameters
    %% method to take in changes to parameter