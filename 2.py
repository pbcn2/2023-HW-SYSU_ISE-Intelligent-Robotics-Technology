# -*- coding: utf-8 -*-
from scipy.optimize import minimize_scalar
import numpy as np
import matplotlib.pyplot as plt

def plot_function(f, t, num_points=1000, xlabel='t', ylabel='y', title=''):
    """
    Parameters
    ----------
    f : function
        要绘制的函数。
    t : float
        t 的范围是 [0, t]。
    num_points : int, optional
        生成的点数，默认为 1000。
    xlabel : str, optional
        x 轴标签，默认为 't'。
    ylabel : str, optional
        y 轴标签，默认为 'y'。
    title : str, optional
        图像标题，默认为空。
    """
    # 生成 t 的值
    t_values = np.linspace(0, t, num_points)
    # 计算 y 的值
    y_values = f(t_values)
    # 绘制图像
    plt.plot(t_values, y_values)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    plt.text(t_values[0], y_values[0], f'Start: ({int(t_values[0])}, {int(y_values[0])})', fontsize=10)
    plt.text(t_values[-1], y_values[-1], f'End: ({int(t_values[-1])}, {int(y_values[-1])})', fontsize=10)


# list of constants
# Add an additional 0 in front of each group of constants, 
#   and start using them directly from 1 when calling them.
theta_0, theta_0_fd, theta_0_sd = [666, 10, 20], [666, 0, 0], [666, 0, 0] 
theta_f, theta_f_fd, theta_f_sd= [666, 60, 100], [666, 0, 0], [666, 0, 0]

# Parameters to be adjusted
tf = 35
lr = 0.01

# Define the main coefficients
a0 = [theta_0[1], theta_0[2]]
a1 = [0, 0]
a2 = [0, 0]
for i in range(10000):
    tf = tf - lr
    a3 = [10*(theta_f[1]-theta_0[1]) / tf**3, \
          10*(theta_f[2]-theta_0[2]) / tf**3]
    a4 = [-15*(theta_f[1]-theta_0[1]) / tf**4, \
          -15*(theta_f[2]-theta_0[2]) / tf**4]
    a5 = [6*(theta_f[1]-theta_0[1]) / tf**5, \
          6*(theta_f[2]-theta_0[2]) / tf**5]
    def fd_0(t):  # 第1个关节的一阶导
        return a1[0] + 2 * a2[0] * t + 3 * a3[0] * t**2 + 4 * a4[0] * t**3 + 5 * a5[0] * t**4
    def sd_0(t):  # 第1个关节的二阶导
        return 2 * a2[0] + 6 * a3[0] * t + 12 * a4[0] * t**2 + 20 * a5[0] * t**3
    def fd_1(t):  # 第2个关节的一阶导
        return a1[1] + 2 * a2[1] * t + 3 * a3[1] * t**2 + 4 * a4[1] * t**3 + 5 * a5[1] * t**4
    def sd_1(t):  # 第2个关节的二阶导
        return 2 * a2[1] + 6 * a3[1] * t + 12 * a4[1] * t**2 + 20 * a5[1] * t**3
    det_max_fd_0 = minimize_scalar(lambda x: -abs(fd_0(x)), bounds=(0, tf), method='bounded')
    det_max_fd_1 = minimize_scalar(lambda x: -abs(fd_1(x)), bounds=(0, tf), method='bounded')
    det_max_sd_0 = minimize_scalar(lambda x: -abs(sd_0(x)), bounds=(0, tf), method='bounded')
    det_max_sd_1 = minimize_scalar(lambda x: -abs(sd_1(x)), bounds=(0, tf), method='bounded')

    det_max_fd_0 = abs(det_max_fd_0.fun)
    det_max_fd_1 = abs(det_max_fd_1.fun)
    det_max_sd_0 = abs(det_max_sd_0.fun)
    det_max_sd_1 = abs(det_max_sd_1.fun)

    if det_max_fd_0 > 5 or det_max_sd_0 > 0.5 or det_max_fd_1 > 5 or det_max_sd_1 > 0.5:
        tf = tf + lr
        break

print("tf = ", tf)
def f_0(t):
    return a0[0] + a1[0] * t + a2[0] * t**2 + a3[0] * t**3 + a4[0] * t**4 + a5[0] * t**5
def f_1(t):
    return a0[1] + a1[1] * t + a2[1] * t**2 + a3[1] * t**3 + a4[1] * t**4 + a5[1] * t**5
def fd_0(t):  # 第1个关节的一阶导
    return a1[0] + 2 * a2[0] * t + 3 * a3[0] * t**2 + 4 * a4[0] * t**3 + 5 * a5[0] * t**4
def sd_0(t):  # 第1个关节的二阶导
    return 2 * a2[0] + 6 * a3[0] * t + 12 * a4[0] * t**2 + 20 * a5[0] * t**3
def fd_1(t):  # 第2个关节的一阶导
    return a1[1] + 2 * a2[1] * t + 3 * a3[1] * t**2 + 4 * a4[1] * t**3 + 5 * a5[1] * t**4
def sd_1(t):  # 第2个关节的二阶导
    return 2 * a2[1] + 6 * a3[1] * t + 12 * a4[1] * t**2 + 20 * a5[1] * t**3

plt.figure(figsize=(12, 8))

plt.subplot(2, 2, 1)
plot_function(fd_0, tf, xlabel='t', ylabel='abs_theta1_derivative', title='no.1 joint angle first derivative')
plt.axhline(y=5, color='red', label="5") 
plt.legend()

plt.subplot(2, 2, 2)
plot_function(fd_1, tf, xlabel='t', ylabel='abs_theta2_derivative', title='no.2 joint angle first derivative')
plt.axhline(y=5, color='red', label="5") 
plt.legend() 

plt.subplot(2, 2, 3)
plot_function(sd_0, tf, xlabel='t', ylabel='abs_theta1_2-derivative', title='Second derivative of the no.1 joint angle')
plt.axhline(y=0.5, color='red', label="0.5") 
plt.legend() 

plt.subplot(2, 2, 4)
plot_function(sd_1, tf, xlabel='t', ylabel='abs_theta2_2-derivative', title='Second derivative of the no.2 joint angle')
plt.axhline(y=0.5, color='red', label="0.5") 
plt.legend() 

plt.subplots_adjust(hspace=0.5, wspace=0.3)

plt.figure(figsize=(12, 6))
plot_function(f_0, tf, xlabel='t', ylabel='y', title='no.1 joint angle')
plot_function(f_1, tf, xlabel='t', ylabel='y', title='no.2 joint angle')
plt.subplots_adjust(hspace=0.5)

# Robot motion state diagram
fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('Robot motion state diagram')
ax.set_xlabel('x/m')
ax.set_ylabel('y/m')

for i in range(1, int(tf)+2):
    x1 = np.cos(np.deg2rad(f_0(i)))
    y1 = np.sin(np.deg2rad(f_0(i)))
    x2 = np.cos(np.deg2rad(f_0(i))) + np.cos(np.deg2rad(f_0(i) + f_1(i)))
    y2 = np.sin(np.deg2rad(f_0(i))) + np.sin(np.deg2rad(f_0(i) + f_1(i)))
    ax.plot([0, x1, x2], [0, y1, y2], marker='*')

plt.show()
