import math

p = [0, 0.3000, 0.1732, -0.3000]
a1, a2, a3 = 0, 0.4, 0.6
d1 = 0.5

# solve for theta_3, result is a list with 2 elements
theta_3 = math.acos( ( p[1]**2 + p[2]**2 + (p[3]- 0.5)**2 - 0.4**2 - 0.6**2) / (2*0.4*0.6) )
theta_3 = round(math.degrees(theta_3))
theta_3 = [theta_3, -theta_3]


# solve for theta_2, resunt is a list with 4 elements
A = [a2 + a3 * math.cos(math.radians(theta_3[0])), \
     a2 + a3 * math.cos(math.radians(theta_3[1]))]
B = [a3 * math.sin(math.radians(theta_3[0])), \
     a3 * math.sin(math.radians(theta_3[1]))]
C = d1 - p[3]
fai = [math.degrees(math.atan2(B[0], A[0])), \
       math.degrees(math.atan2(B[1], A[1]))]

theta_2a = math.degrees(math.asin(C / math.sqrt(A[0]**2 + B[0]**2))) - fai[0]
theta_2b = 180 - math.degrees(math.asin(C / math.sqrt(A[0]**2 + B[0]**2))) + fai[0]
theta_2c = math.degrees(math.asin(C / math.sqrt(A[1]**2 + B[1]**2))) - fai[1]
theta_2d = 180 - math.degrees(math.asin(C / math.sqrt(A[1]**2 + B[1]**2))) + fai[1]

theta_2 = [theta_2a, theta_2b, theta_2c, theta_2d]
for i in range(4):
    theta_2[i] = round(theta_2[i])


# solve for theta_1, resunt is a list with 4 elements
theta_2_r = []
theta_3_r = []
for i in range(2):
    theta_3_r.append(math.radians(theta_3[i]))
for i in range(4):
    theta_2_r.append(math.radians(theta_2[i]))

theta_1 = []
for i in range(2):
     if i == 0:
          for j in range(0,2):
               t = math.atan2(p[1]/( a2*math.cos(theta_2_r[j]) + a3*math.cos(theta_2_r[j]+theta_3_r[i])), \
                              p[0]/( a2*math.cos(theta_2_r[j]) + a3*math.cos(theta_2_r[j]+theta_3_r[i])))
               theta_1.append(round(math.degrees(t)))
     else:
          for j in range(2,4):
               t = math.atan2(p[1]/( a2*math.cos(theta_2_r[j]) + a3*math.cos(theta_2_r[j]+theta_3_r[i])), \
                              p[0]/( a2*math.cos(theta_2_r[j]) + a3*math.cos(theta_2_r[j]+theta_3_r[i])))
               theta_1.append(round(math.degrees(t)))


# print
result = []
for i in range(2):
     if i == 0:
          for j in range(2):
               t = [theta_1[j], theta_2[j], theta_3[i]]
               result.append(t)
     else:
          for j in range(2, 4):
               t = [theta_1[j], theta_2[j], theta_3[i]]
               result.append(t)

for i in range(4):
     print(result[i])

# 奇异条件判定
# 显然，不满足肘部奇异条件
# 下面判断肩部奇异条件
flag = 0
for i in result:
     t = a2 * math.cos(i[1]) + a3 * math.cos(i[1]+i[2])
     if t == 0:
          flag = 1
          break
if flag == 1:
     print("奇异")
else:
     print("非奇异")