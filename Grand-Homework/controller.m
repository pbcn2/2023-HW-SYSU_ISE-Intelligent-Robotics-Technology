% Feedforward and PI Control for Robotic Arms
% Mengtang Li, Ph.D. 
% 2023 06 01

function [control, Xerr] = controller(X, Xd, Xdnext, Kp, Ki, dt, thetalist)
% 
% This function calculates the kinematic task-space feedforward plus 
% feedback control law.
% INPUT:
% 1. The current actual end-effector configuration X (also written Tse).
% 2. The current end-effector reference configuration Xd (i.e., Tse,d).
% 3. The end-effector reference configuration at the next timestep in the
%    reference trajectory, Xd,next (i.e., Tse,d,next), at a time \Delta t later.
% 4. The PI gain matrices Kp and Ki.
% 5. The timestep \Delta t between reference trajectory configurations.
% 6. The corresponding joint angles, thetalist.
% OUTPUT:
% 1. The commanded end-effector twist \mathcal{V} expressed in the
%    end-effector frame {e}.
% 2. Xerr history to plot.

% ----------------------------------------------------------------------- %
% compute Vb
% PUT YOUR CODE HERE! %
Vd = se3ToVec(1/dt*MatrixLog6(Xd\Xdnext));
AdXinvXdVd = Adjoint(X\Xd)*Vd;
Xerr = se3ToVec(MatrixLog6(X\Xd));
Vb = AdXinvXdVd + Kp*Xerr + Ki*(Xerr*dt);

% list Blist 
% PUT YOUR CODE HERE! %
W1 = 109e-3; W2 = 82e-3;
L1 = 425e-3; L2 = 392e-3;
H1 = 89e-3; H2 = 95e-3;
Blist = [0     0        0   0   0   0;
         1     0        0   0  -1   0;
         0     1        1   1   0   1;
         W1+W2 H2       H2  H2 -W2  0;
         0     -L1-L2  -L2  0   0   0;
         L1+L2  0       0   0   0   0;
         ];

% compute Jb
% PUT YOUR CODE HERE! 
Jb = JacobianBody(Blist, thetalist);

% compute control
% PUT YOUR CODE HERE! 
control = pinv(Jb,1e-2)*Vb;

end