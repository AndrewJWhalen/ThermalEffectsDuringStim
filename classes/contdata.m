classdef contdata
    properties
        initialdata
        profile_t
        current_t
        fin
        tc
        tstart
        last
        ss
        dT
        last2
    end
    methods
        function [p,c] = same(obj)
            addpath(obj.initialdata.function_path)
            [p,c] = obj.initialdata.function_name(obj.initialdata.profile_0, obj.initialdata.bath, obj.initialdata.init, obj.initialdata.init, 1, 1, obj.last, 0.1,0.02);
            rmpath(obj.initialdata.function_path)
        end
        function [p,c] = change(obj)
            addpath(obj.initialdata.function_path)
            [p,c] = obj.initialdata.function_name(obj.initialdata.profile_0, obj.initialdata.bath, obj.initialdata.init, obj.fin, obj.tc, obj.tstart, obj.last, obj.ss,obj.dT);
            rmpath(obj.initialdata.function_path)
        end
        function [p,c] = changereturn(obj)
            addpath(obj.initialdata.function_path)
            [p1,c1] = obj.initialdata.function_name(obj.initialdata.profile_0, obj.initialdata.bath, obj.initialdata.init, obj.fin, obj.tc, obj.tstart, obj.last, obj.ss,obj.dT);
            [p2,c2] = obj.initialdata.function_name(p1(:,end), obj.initialdata.bath, obj.fin, obj.initialdata.init, obj.tc, obj.tstart, obj.last2, obj.ss,obj.dT);
            p = [p1,p2(:,2:end)];
            c = [c1,c2];
            rmpath(obj.initialdata.function_path)
        end
        function obj = contdata(initialdata,fin,tc,tstart,last,ss,dT,last2)
            obj.initialdata = initialdata;
            obj.fin = fin;
            obj.tc = tc;
            obj.tstart = tstart;
            obj.last = last;
            obj.ss = ss;
            obj.dT = dT;
            obj.last2 = last2;
        end
    end
            
end
