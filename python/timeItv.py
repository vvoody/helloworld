# encoding:UTF-8
#
# revision 2007.04.29 :
#	正则升级为带组名，
#	升级局部变量命名规则，
#	升级itv2time返回值表达式
# revision 2007.03.31 :
#	启动版本，
#	基本功能实现
# you can use for :
#	计算与日期无关的时分秒级别的时间差
#	如计算加班时间，电影字幕时间修正
# timeItv.py

import re

# 将计时器"时:分:秒"字符串转换为秒数间隔
def time2itv(_sTime):

    _sP="^(?P<h>[0-9]+):(?P<m>[0-5][0-9]):(?P<s>[0-5][0-9])$"
    _p=re.compile(_sP)
    _mTime=_p.match(_sTime)
    
    if _mTime:
        t=map(int,_mTime.group('h','m','s'))
        return 3600*t[0]+60*t[1]+t[2]
    else:
    	return "[InModuleError]:time2itv(_sTime) invalid argument value"


# 将秒数间隔转换为计时器"时:分:秒"字符串
def itv2time(_iItv):

    if type(_iItv)==type(1):
        h=_iItv/3600
        sUp_h=_iItv-3600*h
        m=sUp_h/60
        sUp_m=sUp_h-60*m
        s=sUp_m
        return '%02i:%02i:%02i'%(h,m,s) 
    else:
        return "[InModuleError]:itv2time(_iItv) invalid argument type"


if __name__=="__main__":
    # 用法示例仅供测试
    sTime="1223:34:15"
    itv=time2itv(sTime)
    print itv               # 4404855
    print itv2time(itv)     # 1223:34:15

    # ！不合约定的参数
    print time2itv("12:34:95")
    print time2itv("sfa123")
    # print time2itv(itv)	
    print itv2time("451223")
    print itv2time(sTime)

    print itv2time(time2itv('19:12:00') - time2itv('09:03:00') )
	
