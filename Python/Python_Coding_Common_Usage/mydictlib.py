import time as tm
import numpy as np
import pandas as pd

MyFlag1 = 1   # global test varible
MyFlag2 = 2   # global test varible
MyFlag3 = 3   # global test varible

MyLoopStart = False  # flag to mart the starting of loop
MyTimeLast = 0       # save the last value of clock
MyTimeInterval = 5   # time interval of calculation
MyCounter = 0

# Make mapping of dataframes by using dict
def NewDict(codelist):
    newDict = {}
    for code in codelist:
        # Add empty dataframe to dictCodes
        newDict[code] = pd.DataFrame()
    return newDict
    
# Assign random dataframe (dfx) to the dictionary
def AppendRandomDataFrame(mydict,code):
    global StockCodes
    
    dfx = pd.DataFrame(np.random.rand(5,3))
    dfx.columns = [code+'_Col1',code+'_Col2',code+'_Col3']    

    # Add dfx to dictCodes
    dfy = mydict[code]
    mydict[code] = dfy.append(dfx)
    
    
# Sample code frame of a calculation function
def CalcFunc1(mydict,code):
	dfx = mydict[code]
	return dfx
	

# Sample code frame of a function that does something periodically
def CalcFuncPeriod():
	global MyLoopStart
	global MyTimeLast, MyTimeInterval, MyCounter
	
	runflag = False      # flag to be checked to enbale the running of calculation
	clknow = tm.clock()  # get value of clock
	
	if not MyLoopStart:      # running for the 1st time ?
		MyLoopStart = True
		runflag = True
		MyTimeLast = clknow	
	elif (clknow - MyTimeLast) >= MyTimeInterval:  # run out of interval time?
		runflag = True
		MyTimeLast = clknow
	
	if not runflag:           # enable the running of calculation?
		return runflag
	
	##########################################	
	
	MyCounter += 1
	print '[CalcFuncPeriod]: counter = '+str(MyCounter)
	
	##########################################	

	return runflag        