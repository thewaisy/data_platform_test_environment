from kafka import KafkaProducer
from json import dumps
import pymysql
import time
import string
import random

suffle_case = string.ascii_uppercase + string.digits
mysql = pymysql.connect(
    user='root',
    passwd='donghyun',
    host='localhost',
    db='waisy',
    charset='utf8'
)

producer = KafkaProducer(acks=0, compression_type='gzip', bootstrap_servers=['localhost:9092'],
                         value_serializer=lambda x: dumps(x).encode('utf-8'))

start = time.time()
cursor = mysql.cursor(pymysql.cursors.DictCursor)
sql = f"""
    select 
    * 
    from best_seller
    where 
    Name like '{random.choice(suffle_case)}%'
    limit 1;
    """
cursor.execute(sql)
result = cursor.fetchall()

data = {'str' : 'result'}
producer.send('best_seller', value=result[0])
producer.flush()

print("elapsed :", time.time() - start)
