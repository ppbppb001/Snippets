
# coding: utf-8

# In[1]:


import snap


# In[7]:


# create a graph PNGraph
G1 = snap.TNGraph.New()
G1.AddNode(1)
G1.AddNode(5)
G1.AddNode(32)
G1.AddEdge(1,5)
G1.AddEdge(5,1)
G1.AddEdge(5,32)
print ("G1: Nodes %d, Edges %d" % (G1.GetNodes(), G1.GetEdges()))


# In[8]:


# create a directed random graph on 100 nodes and 1k edges
G2 = snap.GenRndGnm(snap.PNGraph, 100, 1000)
print ("G2: Nodes %d, Edges %d" % (G2.GetNodes(), G2.GetEdges()))


# In[11]:


# traverse the nodes
for NI in G2.Nodes():
    print ("node id %d with out-degree %d and in-degree %d" % (
            NI.GetId(), NI.GetOutDeg(), NI.GetInDeg()))


# In[10]:


# traverse the edges
for EI in G2.Edges():
    print ("edge (%d, %d)" % (EI.GetSrcNId(), EI.GetDstNId()))


# In[12]:


# traverse the edges by nodes
for NI in G2.Nodes():
    for Id in NI.GetOutEdges():
        print ("edge (%d %d)" % (NI.GetId(), Id))


# In[13]:


# generate a network using Forest Fire model
G3 = snap.GenForestFire(1000, 0.35, 0.35)
print ("G3: Nodes %d, Edges %d" % (G3.GetNodes(), G3.GetEdges()))

