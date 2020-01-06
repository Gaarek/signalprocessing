function [y, state] = LowPass2(varargin)
%LOWPASS2 Second order low-pass filter
%   Initialize with:
%     [~ state] = LowPass2(w, z)
%   Filter with:
%     [y, state] = LowPass2(x, time, state)
%
%   w: Bandwidth [rad/s]
%   z: Damping coefficient, typically 0.5-1.2
%   state: Internal state of the filter, input and output should be the
%          same variable
%   x: Input value to filter
%   time: Time stamp of x
%   y: Filtered output

if (nargin == 3)
    x = varargin{1};
    time = varargin{2};
    state = varargin{3};
    
    if not(state.firstSample)
        %This handles changing time step, but not really.
        %It is still assumed that the tim step between n -> n-1 -> n-2 is
        %constant, which it doesnt have to be.
        %Kind of works, but needs further work.
        %Handled now by interpolation
        
        dt = time - state.oldTime;
        dtOld = state.oldTime - state.oldOldTime;
        
        %Move either n-1 or n-2 to make time steps uniform and dont
        %extrapolate (new points between oldOldTime and time)
        if (dt <= dtOld)
            dtOldinv = 1/dtOld;
            xm1 = state.xm1;
            ym1 = state.ym1;
            xm2 = state.xm1 - dt * (state.xm1 - state.xm2)*dtOldinv;
            ym2 = state.ym1 - dt * (state.ym1 - state.ym2)*dtOldinv;
        else
            xm2 = state.xm2;
            ym2 = state.ym2;
            xm1 = x - dtOld * (x - state.xm1)/dt;
            ym1 = state.ym2 + (dt + dtOld)/2 * (state.ym1 - state.ym2)/dtOld;
            dt = dtOld;
        end
        w = state.w;
        K=w/tan(w*dt/2);
        %K=2/dt;
        
        num = state.a0*K^2 + state.a1*K + 1;
        
        y = x +...
            (2 * 1) * xm1 +...
            1 * xm2 +...
            -(2 * 1 - 2 * state.a0 * K^2) * ym1 +...
            -(state.a0 * K^2 - state.a1 * K + 1) * ym2;
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
    y = 0;
end
