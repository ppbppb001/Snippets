
# coding: utf-8

# In[2]:


from collections import defaultdict


# In[4]:


from gensim import corpora
from gensim import models


# In[ ]:


# *** Corpus ***


# In[5]:


raw_corpus = ["Human machine interface for lab abc computer applications",
             "A survey of user opinion of computer system response time",
             "The EPS user interface management system",
             "System and human system engineering testing of EPS",              
             "Relation of user perceived response time to error measurement",
             "The generation of random binary unordered trees",
             "The intersection graph of paths in trees",
             "Graph minors IV Widths of trees and well quasi ordering",
             "Graph minors A survey"]


# In[6]:


# Create a set of frequent words
stoplist = set('for a of the and to in'.split(' '))
# Lowercase each document, split it by white space and filter out stopwords
texts = [[word for word in document.lower().split() if word not in stoplist]
         for document in raw_corpus]
print (texts)


# In[7]:


frequency = defaultdict(int)
for text in texts:
    for token in text:
        frequency[token] += 1

# Only keep words that appear more than once
processed_corpus = [[token for token in text if frequency[token] > 1] for text in texts]
processed_corpus


# In[8]:


dictionary =  corpora.Dictionary(processed_corpus)
print (dictionary)


# In[ ]:


# *** Vector ***


# In[9]:


print (dictionary.token2id)


# In[10]:


new_doc = "Human computer interaction"
new_vec = dictionary.doc2bow(new_doc.lower().split())
new_vec


# In[11]:


bow_corpus = [dictionary.doc2bow(text) for text in processed_corpus]
bow_corpus


# In[ ]:


# *** Model ***


# In[12]:


# train the model
tfidf = models.TfidfModel(bow_corpus)
# transform the "system minors" string
tfidf[dictionary.doc2bow("system minors".lower().split())]

