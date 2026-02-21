import json
import os
import sys
import tempfile
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service

# Load config.json
with open('./config.json') as json_data:
    cfg = json.load(json_data)

def timeout():
    return int(cfg['DEFAULTS']['SLEEP_DELAY'])

def google_img_pages():
    return int(cfg['DEFAULTS']['GOOGLE_IMG_PAGES'])

def google_filter():
    return cfg['FILTER']

def instaLimit():
    return int(cfg['INSTA_VALIDATION_MAX_IMAGES'])

def jitters():
    return int(cfg['JITTERS'])

def getWebDriver():
    if not os.path.isfile(cfg['WEBDRIVER']['PATH']):
        print(f"{cfg['WEBDRIVER']['PATH']} does not exist - install a webdriver")
        sys.exit(-2)
    
    driver_type = cfg['WEBDRIVER']['ENGINE'].lower()
    
    if driver_type == 'firefox':
        options = Options()
        
        # --- ESSENTIAL DOCKER & HEADLESS FLAGS ---
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--window-size=1920,1080")
        
        # --- ADDITIONAL FIXES FOR STATUS 1 CRASHES ---
        options.add_argument("--disable-gpu")
        options.add_argument("--disable-software-rasterizer")
        
        service = Service(executable_path=cfg['WEBDRIVER']['PATH'])
        return webdriver.Firefox(service=service, options=options)
    
    elif driver_type == 'chrome':
        return webdriver.Chrome()
    
    return None