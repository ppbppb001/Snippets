# numpy
import numpy as	np

# pandas
import pandas as pd

class MyDict:
	def	__init__(self,codelist):
		self.dict =	{}
		for	code in	codelist:
			self.dict[code]	= pd.DataFrame()
			
	def	AddCode(self,codelist):
		if type(codelist) == list:
			for	code in	codelist:
				self.dict[code]	= pd.DataFrame()
		elif type(codelist)	== str:
			self.dict[codelist]	= pd.DataFrame()			
		
	def	GetDict(self):
		return self.dict
		
	def	GetDataFrame(self,code):
		dfx = self.dict[code]
		return dfx
		
	def	AppendRandomDataFrame(self,code):
		dfx	= pd.DataFrame(np.random.rand(5,3))
		dfx.columns	= [code+'_Col1',code+'_Col2',code+'_Col3']	  
		dfy	= self.dict[code]
		self.dict[code]	= dfy.append(dfx)
	
	def CalcFunc1(self,code):
		dfx = self.dict[code]
		return dfx
	