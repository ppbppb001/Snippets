
# coding: utf-8

# In[1]:


import snap


# In[2]:


# create a random directed graph
G = snap.GenRndGnm(snap.PNGraph, 10000, 5000)


# In[3]:


# test if the graph is connected or weakly connected
print ("IsConnected(G) =", snap.IsConnected(G))
print ("IsWeaklyConnected(G) =", snap.IsWeaklyConn(G))


# In[4]:


# get the weakly connected component counts
WccSzCnt = snap.TIntPrV()
snap.GetWccSzCnt(G, WccSzCnt)
for i in range (0, WccSzCnt.Len()):
    print ("WccSzCnt[%d] = (%d, %d)" % (
                i, WccSzCnt[i].Val1.Val, WccSzCnt[i].Val2.Val))


# In[6]:


# return nodes in the same weakly connected component as node 1
CnCom = snap.TIntV()
snap.GetNodeWcc(G, 1, CnCom)
print ("CnCom.Len() = %d" % (CnCom.Len()))


# In[7]:


# get nodes in weakly connected components
WCnComV = snap.TCnComV()
snap.GetWccs(G, WCnComV)
for i in range(0, WCnComV.Len()):
    print ("WCnComV[%d].Len() = %d" % (i, WCnComV[i].Len()))
    for j in range (0, WCnComV[i].Len()):
        print ("WCnComV[%d][%d] = %d" % (i, j, WCnComV[i][j]))


# In[8]:


# get the size of the maximum weakly connected component
MxWccSz = snap.GetMxWccSz(G);
print ("MxWccSz = %.5f" % (MxWccSz))


# In[9]:


# get the graph with the largest weakly connected component
GMx = snap.GetMxWcc(G);
print ("GMx: GetNodes() = %d, GetEdges() = %d" % (
    GMx.GetNodes(), GMx.GetEdges()))


# In[10]:


# get strongly connected components
SCnComV = snap.TCnComV()
snap.GetSccs(G, SCnComV)
for i in range(0, SCnComV.Len()):
    print ("SCnComV[%d].Len() = %d" % (i, SCnComV[i].Len()))


# In[11]:


# get the graph representing the largest bi-connected component
GMxBi = snap.GetMxBiCon(G)
print ("GMxBi: GetNodes() = %d, GetEdges() = %d" % (
    GMxBi.GetNodes(), GMxBi.GetEdges()))

