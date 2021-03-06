# script to download all releases from latest release on GitHub repository page

import os
import requests
from github import Github

REPO = 'WZBSocialScienceCenter/lda'

def download_file(url):   # taken from https://stackoverflow.com/a/16696317
    local_filename = 'dist/' + url.split('/')[-1]

    if os.path.exists(local_filename):
        return local_filename, False

    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                # If you have chunk encoded response uncomment if
                # and set chunk_size parameter to None.
                #if chunk:
                f.write(chunk)

    return local_filename, True


g = Github()

print('getting latest release from repository', REPO)

repo = g.get_repo(REPO)
releases = repo.get_releases()

latest_release = list(releases)[0]
print('latest release is', latest_release.tag_name)

assets = latest_release.get_assets()   # from latest release

print('downloading assets')
for asset in assets:
    print('>', asset.name)
    stored_file, downloaded = download_file(asset.browser_download_url)
    if downloaded:
        print('> downloaded to', stored_file)
    else:
        print('> file already exists:', stored_file)

print('done.')
