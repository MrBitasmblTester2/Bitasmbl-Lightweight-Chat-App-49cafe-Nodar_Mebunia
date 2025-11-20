from fastapi import FastAPI
import socketio
from rooms import gen_user, now_ts
sio=socketio.AsyncServer(async_mode='asgi')
app=FastAPI()
sio_app=socketio.ASGIApp(sio,other_asgi_app=app)
@sio.event
async def connect(sid,environ):
 print('connect',sid)
@sio.on('join')
async def on_join(sid,data):
 room=data.get('room')
 user=gen_user(sid)
 sio.enter_room(sid,room)
 await sio.emit('system',{'user':user,'ts':now_ts(),'msg':'joined'},room=room)
@sio.on('message')
async def on_message(sid,data):
 await sio.emit('message',{'user':gen_user(sid),'text':data.get('text'),'ts':now_ts()},room=data.get('room'))
@sio.event
def disconnect(sid):
 print('disconnect',sid)
