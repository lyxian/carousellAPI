import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from Google.main import spreadSheetClient, openWorkbook_name
from flask import Flask, request

def getServer():

    app = Flask(__name__)
    client = spreadSheetClient()

    @app.route('/')
    # Define routes here
    def _index():
        return '''<div><h1>AutoCarousell API Manual</h1><h3>Available method</h3>
        <ol>
            <li>start</li>
            <li>stop</li>
            <li>hello</li>
        </ol></div>''', 200

    # List workbooks
    @app.route('/workbooks')
    def _workbooks():
        return {
            'results': {
                'workbooks': [workbook['name'] for workbook in client.list_spreadsheet_files() if 'Automated' in workbook['name']]
            }
        }, 200

    # List queries
    @app.route('/workbook/<name>/queries')
    def _queries(name):
        wb = openWorkbook_name(client, f'Automated Carousell-{name.capitalize()}')

        notResults = ['First', 'Settings']
        queryResults = [worksheet.title for worksheet in wb.worksheets() if worksheet.title not in notResults]

        return {
            'results': {
                'queries': queryResults
            }
        }, 200

    # List query results
    @app.route('/workbook/<name>/query/<query>')
    def _query(name, query):
        # Required Params: after=<datetime> , before=<datetime> , query
        # <datetime> - DD-MM-YYYY HH:MM AM/PM (%p)
        params = ['after', 'before', 'query']
        after = request.args.get('after', None)
        before = request.args.get('before', None)
        print(after,before)
        if after and before and query:
            msg = f'Querying for "{query}" between {after} and {before}'
            return {
                'success': msg
            }, 200
        else:
            msg = f'Missing required params: {[k for k, v in dict(zip(params, [after,before,query])).items() if not v]}'
            return {
                'failure': msg
            }, 400

        wb = openWorkbook_name(client, f'Automated Carousell-{name.capitalize()}')

        notResults = ['First', 'Settings']
        queryResults = [worksheet.title for worksheet in wb.worksheets() if worksheet.title not in notResults]

        return {
            'results': {
                'queries': queryResults
            }
        }, 200

    return app