# Bitasmbl-Lightweight-Chat-App-49cafe-Nodar_Mebunia

## Description
Build a web application that allows users to join anonymous chatrooms and exchange messages in real-time using WebSockets. The focus is on fast communication, simple interface, and responsive updates without requiring user registration.

## Tech Stack
- Objective-C
- FastAPI
- Socket.IO

## Requirements
- Allow users to join chatrooms without authentication
- Gracefully handle disconnected users and reconnections
- Handle multiple chatrooms simultaneously
- Display messages with timestamps and user identifiers (anonymous)
- Send and receive messages in real-time using WebSockets

## Installation
Follow these steps to set up the project locally. Adjust paths and commands to match your environment.

1. Clone the repository (replace the repository name if needed):

   git clone https://github.com/MrBitasmblTester2/Lightweight-Chat-App.git
   cd Lightweight-Chat-App

2. Backend (FastAPI + Socket.IO)

   - Create and activate a Python virtual environment (recommended):

     python3 -m venv .venv
     source .venv/bin/activate

   - Install required Python packages. This project uses FastAPI and a Socket.IO server implementation:

     pip install fastapi python-socketio uvicorn

   - (Optional) If a requirements.txt is provided in the repo, you can instead run:

     pip install -r requirements.txt

3. Objective-C client

   - Open the Objective-C client project in Xcode. From the repository root, locate the Objective-C client folder (for example: client/ObjectiveCApp) and open the Xcode project or workspace:

     open client/ObjectiveCApp/LightweightChatApp.xcodeproj

   - Build the project in Xcode. If the client depends on a Socket.IO client library, add/restore that dependency using your preferred dependency manager or include the library source according to the project instructions in the repo.

Note: No environment variables are strictly required by the stacks listed; configure host and port in client or backend configuration files if present in the repository.

## Usage
Start the backend server and run the Objective-C client.

1. Start the FastAPI backend with Uvicorn (from the repository root, with the virtualenv active):

   uvicorn main:app --host 0.0.0.0 --port 8000 --reload

   - This command assumes the FastAPI app instance is in a module named main and exposed as app. Adjust the module and object name if the repository uses different names.
   - The Socket.IO server should be mounted/served together with FastAPI so Socket.IO clients can connect (for example on ws://localhost:8000/socket.io/).

2. Run the Objective-C client:

   - In Xcode, select a simulator or device and run the project.
   - Configure the client to point to the backend server address (e.g., http://localhost:8000 or ws://localhost:8000/socket.io/). The client should allow joining a chatroom name and sending/receiving messages in real-time.

3. Testing multiple users and rooms:

   - Open multiple instances of the client (simulators or devices) and join the same or different room names to verify real-time messaging and that multiple chatrooms operate concurrently.

## Implementation Steps
1. Initialize the FastAPI project and create an ASGI app (e.g., app = FastAPI()).
2. Integrate a Socket.IO server implementation for Python (python-socketio) with ASGI and attach it to the FastAPI app so Socket.IO clients can connect.
3. Implement connection handlers:
   - on connect: generate a temporary anonymous user identifier (e.g., UUID) and return it to the client so the client can reuse it across reconnects.
4. Implement room management server-side using Socket.IO room mechanics:
   - join room event: add socket to the requested room; maintain an in-memory mapping of room -> connected user ids for optional presence tracking.
   - leave room event: remove socket from the room mapping.
5. Implement message handling events:
   - Accept message payloads from clients that include room name, user identifier (anonymous), and message text.
   - Server timestamps messages on receipt (ISO 8601) and broadcasts the message to all sockets in the room via Socket.IO emits.
6. Ensure messages include: timestamp, anonymous user identifier, and message text in the broadcast payload so clients can render them accordingly.
7. Handle disconnects and reconnections:
   - on disconnect: mark the socket as disconnected and optionally broadcast a presence update to the room; keep a short-lived mapping if you want to allow quick reconnection.
   - on reconnect: if the client presents the previously issued anonymous identifier, re-associate the new socket session with that identifier and rejoin requested rooms.
8. Support multiple chatrooms concurrently by using per-room namespaces or room names provided in events, and ensure the Socket.IO server routes events to the correct room.
9. Implement simple in-memory data structures for active rooms and members. For production or durable state, replace with a persistent store (not required by this project scope).
10. Build the Objective-C client UI:
    - Provide an input to join or create a room by name (no authentication).
    - Show a message list with each message rendered with timestamp and anonymous user identifier.
    - Provide an input to send messages to the currently joined room over Socket.IO.
11. Integrate a Socket.IO client compatible with Objective-C in the client project and establish Socket.IO event handlers that mirror the server events (connect, disconnect, message, join/leave events).
12. Test edge cases:
    - Rapid disconnect/reconnect cycles to ensure graceful handling.
    - Multiple rooms and multiple clients per room to confirm correct message routing and timestamping.

## API Endpoints (Optional)
No REST API endpoints are required by the core requirements; real-time behavior is provided via Socket.IO WebSocket events served by the FastAPI application. If you include lightweight HTTP endpoints, typical examples might be a health check (GET /health) or an active rooms listing (GET /rooms), but these are optional and not required by the given requirements.