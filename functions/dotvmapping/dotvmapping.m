% this code will plot dotv as a function of V at different concentration

function dotvmapping(p_list)

    profile_t = p_list{2,1};
    vmin = -65; vmax = -58;
    pump = 1;
    tmax = 30;

    f = figure;
    xt = 0.0001:0.0001:tmax;

    ax1 = axes('Parent',f,'position',[0.05 0.30 0.40 0.65]);
    ax2 = axes('Parent',f,'position',[0.55 0.30 0.40 0.65]);
    param = ones(1,9);
    param(1) = pump;
    param(8) = 1.5;
   


    plot(ax2, xt, profile_t(1,1:tmax*10000),'Color','b')
    h2 = line(ax2, [5 5], [-80 40],'Color','r');
    h1 = plot(ax1,vmin:0.1:vmax,dotvplot(profile_t(:,50000),[vmin, vmax],param),'Color','b');
    line(ax1,[vmin vmax], [0 0],'Color','r')
    
    set(ax1, 'Xlim',[-65 -58], 'Ylim',[-0.2 0.4])


     b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419+1000,23],...
                  'value',5, 'min',0, 'max',tmax,'Callback', @update, 'SliderStep',[0.001 0.05]);
     bgcolor = f.Color;
     bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                     'String','0','BackgroundColor',bgcolor);
     bl2 = uicontrol('Parent',f,'Style','text','Position',[500+1000,54,23,23],...
                     'String',num2str(tmax),'BackgroundColor',bgcolor);
     bl3 = uicontrol('Parent',f,'Style','text','Position',[240+500,25,100,23],...
                     'String','Time','BackgroundColor',bgcolor);
     bl4 = uicontrol('Parent',f,'Style','text','Position',[240+500,83,100,23],...
                     'String','5','BackgroundColor',bgcolor);



    function update(src, evt)
        set(h1,'YData', dotvplot(profile_t(:,round(src.Value*10000)),[vmin, vmax],param));
        set(h2,'XData', [src.Value src.Value]);
        set(bl4,'String', src.Value);
    end



    % 
    % 
    % 
    % zeta = .5;                           % Damping Ratio
    % wn = 2;                              % Natural Frequency
    % sys = tf(wn^2,[1,2*zeta*wn,wn^2]); 
    % 
    % 
    % 
    % f = figure;
    % ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
    % h = stepplot(ax,sys);
    % setoptions(h,'XLim',[0,10],'YLim',[0,2]);
    % 
    % 
    % b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
    %               'value',zeta, 'min',0, 'max',1);
    % bgcolor = f.Color;
    % bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
    %                 'String','0','BackgroundColor',bgcolor);
    % bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
    %                 'String','1','BackgroundColor',bgcolor);
    % bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
    %                 'String','Damping Ratio','BackgroundColor',bgcolor);
    %             
    % b.Callback = @(es,ed) updateSystem(h,tf(wn^2,[1,2*(es.Value)*wn,wn^2])); 
end