#!.venv/bin/python3


import sys
import time
import subprocess


def get_sso_cookie():
    driver = webdriver.Firefox()
    driver.get('https://vpn.utexas.edu/iso-staff')
    for i in range(60):
        try:
            cookie = driver.get_cookie('webvpn')
            if cookie is not None:
                break
        except Exception as e:
            print(f'error getting cookie\n{e}')
            sys.exit(1)
        time.sleep(1)
    time.sleep(2)
    driver.close()
    driver.quit()
    return cookie['value']


if __name__ == '__main__':
    try:
        from selenium import webdriver
    except:
        print('''
        it looks like you're missing the selenium python package. the best way to install it is using a virtual environment.
        to create a venv and install selenium, copy/paste these commands into your terminal:
        
        ```
        python3 -m venv /tmp/openconnect_venv
        source /tmp/openconnect_venv/bin/activate
        pip install selenium
        ```
        
        everytime you use this script, you'll first need run this to activate the venv:
        
        ```
        source /tmp/openconnect_venv/bin/activate
        ```
        
        then you can run the script as:
        
        ```
        ./openconnect-sso.py
        ```
        ''')
        sys.exit(1)

    cookie = get_sso_cookie()
    # print(f"got cookie:\n{cookie}")
    proc = subprocess.call(["sudo", "openconnect", 'vpn.utexas.edu/iso-staff', '-v', f'--cookie={cookie}'])
