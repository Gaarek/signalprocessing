dt=0.01;
tl=-4:dt:10;

stepTime = 0;

figure(1);
hold off;
for i=[0, 2, 20]
    [~, state] = LowPass2(3, 0.707);
    yl=[];
    ytl=[];
    t=min(tl);
    while t<= max(tl)        
        if (t < stepTime)
            x=0;
        else
            x=1;
        end
        [y, state] = LowPass2(x, t, state);
        yl(end+1) = y;
        ytl(end+1) = t;
        
        t = t + dt *( 1 + i * rand(1,1)); 
    end
    
    plot(ytl, yl)
    hold all;
end