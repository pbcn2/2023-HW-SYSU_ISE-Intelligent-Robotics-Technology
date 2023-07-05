% clear;clc;

% STEP1
% PUT YOUR CODE HERE! %
% Call trajectory generator function to generate trajectory
run trajectoryGenerator.m

% STEP2
% PUT YOUR CODE HERE! %
W1 = 109e-3; W2 = 82e-3;
L1 = 425e-3; L2 = 392e-3;
H1 = 89e-3; H2 = 95e-3;

Slist = [0 0 0 0 0 0;
         0 1 1 1 0 1;
         1 0 0 0 -1 0;
         0 -H1 -H1 -H1 -W1 H2-H1;
         0 0 0 0 L1+L2 0;
         0 0 L1 L1+L2 0 L1+L2];

Blist = [0 0 0 0 0 0;
         1 0 0 0 -1 0;
         0 1 1 1 0 1;
         W1+W2 H2 H2 H2 -W2 0;
         0 -L1-L2 -L2 0 0 0;
         L1+L2 0 0 0 0 0];

M = [-1 0 0 L1+L2;
      0 0 1 W1+W2;
      0 1 0 H1-H2;
      0 0 0 1];

% STEP3
% PUT YOUR CODE HERE! %
Kp = 2;
Ki = 0.2;
result_conf = zeros(N-2, 6);
result_Xerr = zeros(N-2, 6);
result_control = zeros(N-2, 6);

% STEP4
% PUT YOUR CODE HERE! %
X = Tseini; % initialize (only use once)
Xd = result_traj{1}; % initialize (only use once)
Xdnext = result_traj{2}; % initialize (only use once)
thetalist = [0; 0; 0; 0; 0; 0]; % 6x1 column vector
current_conf = [0 0 0 0 0 0]; % 1x6 joint angles

for i = 1:(N-2)
% STEP5
% PUT YOUR CODE HERE! %
    thetalist = current_conf';

    % function [control, Xerr] = controller(X, Xd, Xdnext, Kp, Ki, dt, thetalist)
    [control, Xerr] = controller(X, Xd, Xdnext, Kp, Ki, dt, thetalist);

    % function [next_conf] = nextState(current_conf, control, dt)
    next_conf = nextState(current_conf, control, dt);

    % Store values in result matrices
    result_conf(i, :) = next_conf;
    result_Xerr(i, :) = Xerr';
    result_control(i, :) = control';

    thetalist = next_conf';

    % Calculate end effector pose
    X = FKinSpace(M, Blist, thetalist);

    % Set current and next desired end effector poses
    Xd = result_traj{i+1};
    Xdnext = result_traj{i+2};

    % Update current_conf for the next iteration
    current_conf = next_conf;
end

% STEP6
% PUT YOUR CODE HERE! %
disp('Configuration Computation Done.');
csvwrite('result_conf.csv',result_conf); % save as csv
csvwrite('result_Xerr.csv',result_Xerr); % save as csv
disp('CSV file Written Done.');