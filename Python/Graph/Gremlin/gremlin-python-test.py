
# coding: utf-8

# In[1]:


import time

# --- Import Gremlin-Python modules ---
import gremlin_python
import gremlin_python.driver.serializer as se
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from gremlin_python.driver.client import Client
from gremlin_python.driver.serializer import GraphSONSerializersV2d0
from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.anonymous_traversal import traversal
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.process.traversal import T
from gremlin_python.process.traversal import Order
from gremlin_python.process.traversal import Cardinality
from gremlin_python.process.traversal import Column
from gremlin_python.process.traversal import Direction
from gremlin_python.process.traversal import Operator
from gremlin_python.process.traversal import P
from gremlin_python.process.traversal import Pop
from gremlin_python.process.traversal import Scope
from gremlin_python.process.traversal import Barrier
from gremlin_python.process.traversal import Bindings
from gremlin_python.process.traversal import WithOptions
# ---------------------------------------


# In[2]:


# Function: check response message from gremlin server
# return: (flag, result_list).
#          if successed, flag == True and result_list holds the message/data if available.
#          if failed, flag == False and result_list holds the raised error message.
def CheckResult(result):
    if result is not None:
        i = 0
        while result.done.running():
            time.sleep(0.1)
            i +=1
#             print (i)
            if i>300:
                break

        a = result.all()
        s = str(a)
        ss= s.lower()
        if 'finished' in ss:
            if 'error' in ss:
                return False, [s]
            else:
                return True, a.result()
        else:
            return False, [s]
    else:
        return False, []


# In[ ]:


# ****************************************************
#  Connect to gremlin server
# ****************************************************


# In[3]:


# --- Create client to do low-level operations with gremlin server ---
client = Client("ws://192.168.1.52:8182/gremlin",    # URL of gremlin server (janusgraph application interface)
                "g",                                 # name of traversal object
                username="",                         # username to access Janusgraph
                password="")                         # password to access Janusgraph
print (client)


# In[4]:


res = client.submit('Gremlin.version()')
f,x = CheckResult(res)
print (f)
print ('Version of gremlin server is ',x)


# In[ ]:


# ****************************************************
#  Create a new graph property with Janusgraph
# ****************************************************


# In[ ]:


# --- Create graph on the remote gremlin server: ---
# res = client.submit("graph = TinkerGraph.open()")                  # with Gremlin Server
# res = client.submit("graph = JanusGraphFactory.open('inmemory')")  # with JanusGraph
# CheckResult(res)     # Ignore the 'rasised GremlinServerError' message and go ahead


# In[ ]:


# --- launch an operation of loading graphml data file on remote server: ---
# res = client.submit("graph.io(graphml()).readGraph('c:/datatools/~test/air-routes.graphml')")
# CheckResult(res)


# In[ ]:


# ****************************************************
#  Check/Open exitsting graph properties in Janusgraph
# ****************************************************


# In[5]:


#  Checking existings graph properties - ALL
res = client.submit('JanusGraphFactory.getGraphNames()')
CheckResult(res)


# In[6]:


#  Checking existings graph properties
res = client.submit('ConfiguredGraphFactory.getGraphNames()')
CheckResult(res)


# In[7]:


# --- Open the selected existing graph property on the remote Janusgraph server: ---
res = client.submit("graph = ConfiguredGraphFactory.open('airroutes')")  # 'airrouts' is a already created graph
CheckResult(res)       # Ignore the 'rasised GremlinServerError' message and go ahead


# In[ ]:


# **************************************************************
#  Test client.submit approach which simulate a gremlin console
# **************************************************************


# In[8]:


# <Test-1> --- Check graph's features ---
res = client.submit("graph.features()")
f,r = CheckResult(res)
if f:
    print (r[0])


# In[9]:


# <Test-2> --- Create graph traversal object g ---
res = client.submit("g = graph.traversal()")
CheckResult(res)    # Ignore the 'rasised GremlinServerError' message and go ahead


# In[10]:


# <Test-3> --- Optional sample code using client method ---
#
# WARNING: 
#    The following codes only work with the 'air-routes.graphml' data file!
#

r =  client.submit("g.V().count()").all().result()
print (len(r))
print (r)


# In[11]:


r1 = client.submit("g.V().has('city','Sydney')").all().result()
print (type(r1))
print (r1)
print (len(r1),'vertices')
print (r1[0].id, r1[0].label)


# In[12]:


r2 = client.submit("g.V().has('city','Sydney').has('country','AU')").all().result()
print (len(r2))
print (r2)


# In[13]:


r3 = client.submit("g.V().range(0,10)").all().result()
print (len(r3))
print (r3)


# In[14]:


r4 = client.submit("g.V().range(100,120)").all().result()
print (len(r4))
print (r4)


# In[ ]:


# **************************************************************
#  Test python as a gremlin language variant
# **************************************************************


# In[15]:


# Create graph and remote graph traversal objects (g) by RemoteConnection method:
# Take the most advantages out of Gremlin-Python

# statics.load_statics(globals())

graph = Graph()
print ('type of graph: ',type(graph))

# Binding local traversal object g with the remote traversal object g:
g = graph.traversal().withRemote(
        DriverRemoteConnection('ws://192.168.1.52:8182/gremlin', # URL of gremlin server (janusgraph application interface)
                               'g',                              # name of traversal object
                               username="",                      # username to access Janusgraph
                               password="")                      # password to access Janusgraph 
        )
print ('type of g: ',type(g))


# In[16]:


x1 = g.V().has("city",'Sydney').toList()
print (len(x1))
print (x1)


# In[17]:


x2 = g.V().both()[1:3].toList()
print (len(x2))
print (x2)


# In[18]:


x3 = g.V().range(1,10).toList()
print (len(x3))
print (x3)


# In[19]:


x4 = g.V(x3).toList()
print (len(x4))
print (x4)


# In[20]:


x5 = g.V(x3).id().toList()
print (len(x5))
print (x5)


# In[21]:


g.V().range(0,10).toList()


# In[22]:


# Done and close the client
client.close()

