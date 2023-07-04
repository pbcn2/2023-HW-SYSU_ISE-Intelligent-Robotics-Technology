% Generate a Trajectory for a Robotic Arm
% Mengtang Li, Ph.D. 
% 2023 06 01

clear; clf; close all;


W1 = 109e-3; W2 = 82e-3; L1 = 425e-3; L2 = 392e-3; H1 = 89e-3; H2 = 95e-3;
% input 1: The initial configuration of the end-effector in the 
Tseini = [-1  0  0  L1+L2;
           0  0  1  W1+W2;
           0  1  0  H1-H2;
           0  0  0  1;]; 
% input 2: The desired configuration (test case 1) 
Tsegoal = [-0.500 -0.500 -0.707  0.108;
           -0.500 -0.500  0.707  0.379;
           -0.707  0.707  0.000  0.725;
            0.000  0.000  0.000  1.000;];
% % input 2: The desired configuration (test case 2)
% Tsegoal = [-0.491 -0.533 -0.689  0.372;
%            -0.512 -0.463  0.723  0.589;
%            -0.705  0.708 -0.046  0.358;
%             0.000  0.000  0.000  1.000;];
% input 2: use FK to calculate a valid conf
Slist = [0   0   0   0      0      0;
         0   1   1   1      0      1;
         1   0   0   0     -1      0;
         0  -H1 -H1 -H1    -W1     H2-H1;
         0   0   0   0      L1+L2  0; 
         0   0   L1  L1+L2  0      L1+L2];
theta_d = [30; -45; -20; 0; 0; 0]*pi/180; % it has to be coloumn. Weird.
Tsegoal = FKinSpace(Tseini, Slist, theta_d);
% input 3
k = 1;
% time setp
dt = 0.01; 

% ----------------------------- Traj Gen ----------------------------- %
% Calculate the trajectory duration (Tf)
Tf = norm(Tsegoal - Tseini) / k;

% Calculate the number of trajectory points (N)
N = floor(Tf / dt);

% Set the trajectory generation method
method = 3; % Use method 3 (cubic polynomial interpolation)

% Generate the trajectory
result_traj = ScrewTrajectory(Tseini, Tsegoal, Tf, N, method);

% ----------------------------- Traj Plot ----------------------------- %
n = size(result_traj,2);
x = zeros(1,n);
y = x; z = x;
for i = 1:n
    x(1,i) = result_traj{i}(1,4);
    y(1,i) = result_traj{i}(2,4);
    z(1,i) = result_traj{i}(3,4);
end
figure(1); hold on;
plot3(x,y,z,'b.');
grid on;
for i = 1:10:n
    Rot = result_traj{i}(1:3,1:3);
    Pos = [x(i); y(i); z(i)];
    draw_coordinate_system(0.1,Rot,Pos,'rgb','{b}');
end
axis equal;
xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');
hold off;