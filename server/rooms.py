from datetime import datetime

def gen_user(sid):
 return 'anon-'+sid[:6]

def now_ts():
 return datetime.utcnow().isoformat()+"Z"
