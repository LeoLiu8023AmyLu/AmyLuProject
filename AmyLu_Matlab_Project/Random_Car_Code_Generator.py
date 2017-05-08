# -*- coding: utf-8 -*-
"""
Created on Mon May  8 16:03:43 2017
@author: Anshare_LY
"""
import random

def Random_Car_Code_Generator(NumOfText,city):
    Car_City=''.join(random.sample(city,1))
    Car_Code=""
    for i in range(6):
        if(i<NumOfText):
            Temp=chr(random.randint(67,90)) # 生成随机 A~Z 大写字母
        else:
            Temp=str(random.randint(0,9)) # 生成 0~9 随机数字
        Car_Code=Car_Code+Temp
    Car_Code=random.sample(Car_Code,len(Car_Code)) # 乱序排列
    Car_Code=Car_City+''.join(Car_Code) # 添加城市文字
    print("最终车牌:  "+Car_Code)
    return Car_Code

def main():
    Num_Of_Text=2
    Num_Of_Car_Code=40
    city=['京','津','翼','苏','云','军','粤','沪']
    Car_Code=[]
    for x in range(Num_Of_Car_Code):
        Car_Code.append(Random_Car_Code_Generator(Num_Of_Text,city))
    print(Car_Code)
    
main()