# API for AutoCarousell

### Packages

flask
oauth2client
gspread
requests
cryptography
pandas

### Server-Side

- create routes / host server
- deployment mode:
  - container: run bash command
  - webserver: run function

### Integrations

Telegram

- bot commands:
  - get info
  - create new search

### Test

from Py.Google.main import spreadSheetClient
import pandas as pd

client = spreadSheetClient()
wb = client.open('Automated Carousell-Airflow')
sht = wb.worksheet('macbook')
