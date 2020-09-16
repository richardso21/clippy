import art
import pyperclip
import socket
import time
from socket import gethostbyname, gethostname

IP = gethostbyname(gethostname())
PORT = 8080

art.tprint('cliPPy    v1.0')
print(f'*** Your IPV4 address: {IP} ***\n\n')


sock = socket.socket()
sock.bind(('', PORT))
sock.listen(5)


def sendClipContinuous(conn):
  currentClip = None
  while True:
    try:
      time.sleep(3)

      clipboard = pyperclip.paste()
      if clipboard == currentClip:
        continue
      currentClip = clipboard

      print(f'SENT: {currentClip}')
      conn.send(currentClip.encode())
      
    
    except (ConnectionResetError, 
            ConnectionAbortedError, 
            ConnectionError):
      return 


if __name__ == "__main__":
  while True:
    conn, addr = sock.accept()
    
    print(f'NEW CONNECTION ==> {addr[0]}:{addr[1]}\n\n')
    sendClipContinuous(conn)

    print(f'{addr[0]}:{addr[1]} DISCONNECTED\n\n')
