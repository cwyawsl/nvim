function! Auto_change_themes()
py << EOF

import vim
import os
import pytz
import datetime
from dateutil.tz import tzlocal
from suntime import Sun
import requests as req
import numpy as np

ret = req.get(
        url = 'https://apis.map.qq.com/ws/location/v1/ip',
        params={
            'key': 'GIRBZ-25FCJ-KYSFC-F2ODI-QYOTT-6YBKX'
            }
        ).json()

home = os.environ['HOME']
config_dir = '/.config/nvim/location.npy'
file_path = home + config_dir

if os.path.exists(file_path):
	read_location = np.load(file_path,allow_pickle=True).item()
	latitude = read_location.get('result').get('location').get('lat')
	longtitude = read_location.get('result').get('location').get('lng')

else:
	np.save(file_path,ret)
	read_location = np.load(file_path,allow_pickle=True).item()
	latitude = read_location.get('result').get('location').get('lat')
	longtitude = read_location.get('result').get('location').get('lng')

#latitude = 26.153224357107746
#longitude = 118.16177778433492

today = datetime.datetime.today()
year = today.year
month = today.month
day = today.day
sun = Sun(latitude,longtitude)

abd = datetime.date(year, month, day)
abd_sr = sun.get_local_sunrise_time(abd)
abd_ss = sun.get_local_sunset_time(abd)

now=datetime.datetime.now()
now=now.replace(tzinfo=tzlocal())
now_for_sunrise = now + datetime.timedelta(days=1)

if now_for_sunrise > abd_sr and now < abd_ss:
	vim.command('set background=light')
	vim.command('colorscheme PaperColor')
else:
	vim.command('set background=dark')
	vim.command('colorscheme onedark ')

EOF
endfunction

call Auto_change_themes()
