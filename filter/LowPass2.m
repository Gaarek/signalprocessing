function [y, state] = LowPass2(varargin)
%LOWPASS Summary of this function goes here
%   Detailed explanation goes here

if (nargin == 3)
    x = varargin{1};
    time = varargin{2};
    state = varargin{3};
    
    if not(state.firstSample)
        %This handles changing time step, but not really.
        %It is still assumed that the tim step between n -> n-1 -> n-2 is
        %constant, which it doesnt have to be.
        %Kind of work, but needs further work.
        %Handled now by interpolating xm2/ym2 to time - 2*dt
        %Can still create strange results when time steps vary alot.
        %Especially when the time stepn suddenly increases.
        dt = time - state.oldTime;
        dt2inv = 1/(state.oldTime - state.oldOldTime);
        w = state.w;
        K=w/tan(w*dt/2);
        %K=2/dt;
        
        num = state.a0*K^2 + state.a1*K + state.a2;
        
        xm2 = state.xm1 - dt * (state.xm1 - state.xm2)*dt2inv;
        ym2 = state.ym1 - dt * (state.ym1 - state.ym2)*dt2inv;
        
        y = x +...
            (2*1)*state.xm1 +...
            1*xm2 +...
            -(2 * state.a2 - 2*state.a0 * K^2) * state.ym1 +...
            -(state.a0*K^2 - state.a1*K + state.a2)*ym2;
        y = y/num;
        
        state.ym2 = state.ym1;
        state.ym1 = y;
        state.xm2 = state.xm1;
        state.xm1 = x;
    else
        y = x;
        state.ym1 = y;
        state.ym2 = y;
        state.xm1 = x;
        state.xm2 = x;
        state.firstSample = false;        
        state.oldTime = time - 1;
    end
    state.oldOldTime = state.oldTime;
    state.oldTime = time;
    
elseif (nargin == 2)
    state.firstSample = true;
    state.w = varargin{1};
    state.z = varargin{2};
    state.a0 = 1/state.w^2;
    state.a1 = 2*state.z/state.w;
    state.a2 = 1;
    y = 0;
end
