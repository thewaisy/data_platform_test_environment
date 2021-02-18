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
    host='mysql_5',
    db='waisy',
    charset='utf8'
)

producer = KafkaProducer(acks=0, compression_type='gzip', bootstrap_servers=['kafka:29092'],
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
if len(result):
    print(result[0])
    producer.send('best_seller', value=result[0])
    # producer.send('book', value=data)
    producer.flush()

print("elapsed :", time.time() - start)

