dt=0.01;
tl=-4:dt:10;

stepTime = 0;

figure(1);
hold off;
for i=[0, 2, 30]
    [~, state] = LowPass2(3, 0.707);
    xl=[];
    yl=[];
    
    ytl=[];
    t=min(tl);
    while t<= max(tl)
        if (t < stepTime)
            x=0;
        else
            x=1;
        end
        %         x=x+0.1*randn(1,1);
        [y, state] = LowPass2(x, t, state);
        xl(end+1) = x;
        yl(end+1) = y;
        ytl(end+1) = t;
        
        t = t + dt * (1 + i * rand(1,1));
    end
    plot(ytl, xl, 'LineWidth', 1);
    hold all;
    plot(ytl, yl)
end