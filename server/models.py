from pydantic import BaseModel

class Message(BaseModel):
 room: str
 user: str
 text: str
 ts: str
