#!/usr/bin/env python3

import requests 
import json
import os
import time
import sys
import ipaddress

AP_USER_PASS=('admin', 'admin')

def is_valid_ip(ip):
    try:
        ipaddress.ip_address(ip)
        return True
    except ValueError:
        return False

def apply_config(url):
    body = {
        'type':'apply'
    }

    request_post(url+'/actions', body)

def json_sorting(item):
    if isinstance(item, dict):
        return sorted((key, json_sorting(values)) for key, values in item.items())
    if isinstance(item, list):
        return sorted(json_sorting(x) for x in item)
    else:
        return item

def request_put(url, body, dut_auth=AP_USER_PASS):
    try:
        ret = requests.put(url, auth=dut_auth,
            headers={'Content-type': 'application/json', 'Accept': 'text/plain'}, 
            data=json.dumps(body))  
        return json.loads(ret.text)
    except Exception:
        print_warm('Request PUT')

def request_post(url, body, dut_auth=AP_USER_PASS):
    try:
        ret = requests.post(url, auth=dut_auth,
            headers={'Content-type': 'application/json', 'Accept': 'text/plain'}, 
            data=json.dumps(body))  
        return ret
    except Exception:
        print_warm('Request POST')

def request_get(url, dut_auth=AP_USER_PASS):
    try:
        ret = requests.get(url, auth=dut_auth,
            headers={'Content-type': 'application/json', 'Accept': 'text/plain'})                 
        return ret
    except Exception:
        print_warm('Request GET')

def print_status(msg):
    print('[{:.4f}]'.format(time.time()), os.path.basename(__file__),':', msg)

def print_warm(msg):
    print_status('[\033[33m\033[1mWARN\033[0;0m\033[0;0m] {}'.format(msg))

def print_success(msg):
    print_status('[\033[32m\033[1mSUCCESS\033[0;0m\033[0;0m] {}'.format(msg))

def print_fail(msg):
    print_status('[\033[31m\033[1mFAIL\033[0;0m\033[0;0m] {}'.format(msg))

def abort(reason='unknown reason'):
    print_status('[\033[31m\033[1mABORT\033[0;0m\033[0;0m] {}'.format(reason))
    os._exit(1)

def print_info(msg):
    print_status('[\033[34m\033[1mINFO\033[0;0m\033[0;0m] {}'.format(msg))

def print_json(msg):
    print_status('\n\r{}'.format(json.dumps(msg, indent=4)))

def print_request_return(ret):
    try:
        print_info(f'Status Code: {ret.status_code}')
        if ret.text:
            print_json(json.loads(ret.text))
    except:
        print_fail(f'Erro in http return object [{ret}]')

def _exec_func(url, auth, data):
    print_request_return(request_get(url+'/test', auth))

def exec_request(url, auth):
    data = {
      "type": "test",
      "data": {
        "macs": [
          "00:1A:3F:9E:6E:CF"
        ]
      }
    } 
    _exec_func(url, auth, data)

if __name__ =="__main__":

    if len(sys.argv) < 4:
        abort('Required arguments: IP_DUT, USER, PASSWORD')
    
    if is_valid_ip(sys.argv[1]):
        ip = 'http://' + sys.argv[1]
    else:
        abort('Invalid IP')
    
    user = sys.argv[2]
    passw = sys.argv[3]

    try:
        exec_request(ip, (user, passw))
    except (KeyboardInterrupt):
        abort('Exit to keyboard')
    except:
        abort('Exit to except')
