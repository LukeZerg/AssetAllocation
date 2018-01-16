# -*- coding: utf-8 -*-
"""
Created on Thu Dec 22 15:28:47 2016

@author: KC002
"""

import sys
reload(sys)
sys.setdefaultencoding('utf-8') #将python默认环境编码设置为utf8，不然编码为ascii同时脚本文件和txt为utf8，会造成矛盾
print sys.getdefaultencoding()
import pandas as pd
dir = u'D:/001Work/10年期国债现券价格.csv'                                   #有中文的话使用unicode

#df = pd.read_excel(dir,has_index_names=None)
df = pd.read_excel(dir)
df.to_csv(u'D:/001Work/10年期国债现券价格.txt', index=False)
