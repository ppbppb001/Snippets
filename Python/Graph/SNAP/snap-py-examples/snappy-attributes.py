
# coding: utf-8

# In[1]:


import snap


# In[2]:


nodes = 10
G = snap.GenFull(snap.PNEANet,nodes)


# In[3]:


# define int, float and str attributes on nodes
G.AddIntAttrN(b"NValInt", 0)
G.AddFltAttrN(b"NValFlt", 0.0)
G.AddStrAttrN(b"NValStr", b"0")


# In[4]:


# define an int attribute on edges
G.AddIntAttrE(b"EValInt", 0)


# In[5]:


# add attribute values, node ID for nodes, edge ID for edges

for NI in G.Nodes():
    nid = NI.GetId()
    val = nid
    G.AddIntAttrDatN(nid, val, b"NValInt")
    G.AddFltAttrDatN(nid, float(val), b"NValFlt")
    G.AddStrAttrDatN(nid, bytes(str(val),'utf-8'), b"NValStr")

    for nid1 in NI.GetOutEdges():
        eid = G.GetEId(nid,nid1)
        val = eid
        G.AddIntAttrDatE(eid, val, b"EValInt")


# In[6]:


# print out attribute values

for NI in G.Nodes():
    nid = NI.GetId()
    ival = G.GetIntAttrDatN(nid, b"NValInt")
    fval = G.GetFltAttrDatN(nid, b"NValFlt")
    sval = G.GetStrAttrDatN(nid, b"NValStr")
    print ("node %d, NValInt %d, NValFlt %.2f, NValStr %s" % (nid, ival, fval, sval))

    for nid1 in NI.GetOutEdges():
        eid = G.GetEId(nid, nid1)
        val = G.GetIntAttrDatE(eid, b"EValInt")
        print ("edge %d (%d,%d), EValInt %d" % (eid, nid, nid1, val))

