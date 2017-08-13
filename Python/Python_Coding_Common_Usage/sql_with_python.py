
# coding: utf-8

# In[ ]:

"""
SQL queries with python
"""


# In[1]:

import mysql.connector as mysqlc
from configparser import ConfigParser


# In[ ]:




# In[ ]:

# method 1 - hard code database configuration
cnx = mysqlc.connect(user='root', password='mysql', host='127.0.0.1', database='world')
cursor = cnx.cursor()


# In[ ]:

cursor.execute('select * from sakila.actor')
# rows = cursor.fetchall()
rows_sele = cursor.fetchmany(20)
rows_sele2 = cursor.fetchmany(10)
cursor.close()


# In[4]:

# practice...
cnx = mysqlc.connect(user='root', password='mysql', host='127.0.0.1')
cursor = cnx.cursor()

sql_command = """
select * from sakila.actor;
"""
cursor.execute(sql_command)
rows = cursor.fetchall()

cursor.close()
len(rows)


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:

# method 2 - read database configuration from config file
parser = ConfigParser()
parser.read('config.ini')

db = {}
section = 'mysql'
if parser.has_section(section):
    items = parser.items(section)
    for item in items:
        db[item[0]] = item[1]
else:
    raise Exception('{0} not found in the {1} file'.format(section, filename))


# In[ ]:

conn = mysqlc.MySQLConnection(**db)
conn.is_connected()


# In[ ]:

conn.close()
print conn.is_connected()


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:



