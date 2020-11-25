function frammer = GetFramer()
    % For movie, figure is invisible 
    figure("visible", "off");
    axis image
    x0 = 100; 
    y0 = 100; 
    width = 1080; 
    height = 1920;
    
    set(gcf,'units','points','position',[x0,y0,width,height]);
    
    frammer = struct('cdata',[],'colormap',[]);
end