p = [0, 0.3000, 0.1732, -0.3000];
a1 = 0; a2 = 0.4; a3 = 0.6;
d1 = 0.5;

% solve for theta_3, result is a list with 2 elements
theta_3 = acos((p(2)^2 + p(3)^2 + (p(4) - 0.5)^2 - 0.4^2 - 0.6^2) / (2 * 0.4 * 0.6));
theta_3 = round(rad2deg(theta_3));
theta_3 = [theta_3, -theta_3];

% solve for theta_2, result is a list with 4 elements
A = [a2 + a3 * cos(deg2rad(theta_3(1))), a2 + a3 * cos(deg2rad(theta_3(2)))];
B = [a3 * sin(deg2rad(theta_3(1))), a3 * sin(deg2rad(theta_3(2)))];
C = d1 - p(4);
fai = [rad2deg(atan2(B(1), A(1))), rad2deg(atan2(B(2), A(2)))];

theta_2a = rad2deg(asin(C / sqrt(A(1)^2 + B(1)^2))) - fai(1);
theta_2b = 180 - rad2deg(asin(C / sqrt(A(1)^2 + B(1)^2))) + fai(1);
theta_2c = rad2deg(asin(C / sqrt(A(2)^2 + B(2)^2))) - fai(2);
theta_2d = 180 - rad2deg(asin(C / sqrt(A(2)^2 + B(2)^2))) + fai(2);

theta_2 = [theta_2a, theta_2b, theta_2c, theta_2d];
for i = 1:4
    theta_2(i) = round(theta_2(i));
end

% solve for theta_1, result is a list with 4 elements
theta_2_r = [];
theta_3_r = [];
for i = 1:2
    theta_3_r(i) = deg2rad(theta_3(i));
end
for i = 1:4
    theta_2_r(i) = deg2rad(theta_2(i));
end

theta_1 = [];
for i = 1:2
     if i == 1
          for j = 1:2
               t = atan2(p(2)/(a2*cos(theta_2_r(j)) + a3*cos(theta_2_r(j)+theta_3_r(i))), ...
                        p(1)/(a2*cos(theta_2_r(j)) + a3*cos(theta_2_r(j)+theta_3_r(i))));
               theta_1(end+1) = round(rad2deg(t));
          end
     else
          for j = 3:4
               t = atan2(p(2)/(a2*cos(theta_2_r(j)) + a3*cos(theta_2_r(j)+theta_3_r(i))), ...
                         p(1)/(a2*cos(theta_2_r(j)) + a3*cos(theta_2_r(j)+theta_3_r(i))));
               theta_1(end+1) = round(rad2deg(t));
          end
     end
end

% print
result = [];
for i = 1:2
    if i == 1
        for j = 1:2
            t = [theta_1(j), theta_2(j), theta_3(i)];
            result = [result; t];
        end
    else
        for j = 3:4
            t = [theta_1(j), theta_2(j), theta_3(i)];
            result = [result; t];
        end
    end
end

for i = 1:4
    disp(result(i,:));
end

% 判断是否奇异
flag = 0;
for i = 1:size(result, 1)
    t = a2 * cos(deg2rad(result(i,2))) + a3 * cos(deg2rad(result(i,2) + result(i,3)));
    if t == 0
        flag = 1;
        break;
    end
end

if flag == 1
    disp("奇异");
else
    disp("非奇异");
end
