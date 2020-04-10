#!/usr/bin/env python3

import urllib.request
import yaml
import sys

def __parse_script(scripts):
    print('parsing scripts')
    versions = []
    "this functions parses and array of script lines looking for PUPPET_VERSION"
    for script in scripts:
        for word in script.split():
            if word.startswith('PUPPET_VERSION'):
              versions.append(word.split('=')[1])
    return list(set(versions))

print(sys.version)
print(sys.path)
#url = 'https://raw.githubusercontent.com/jeannegreulich/pupmod-simp-simp_nfs/SIMP-3435/.gitlab-ci.yml'
url = 'https://raw.githubusercontent.com/simp/pupmod-simp-nfs/6.2.2/.gitlab-ci.yml'

request = urllib.request.urlretrieve(url)
filename = request[0]
file = open(filename, "r")
gitlab_content = yaml.load(file.read(), Loader=yaml.FullLoader)

allow_failure_versions = []
versions = []

for entry in dict.keys(gitlab_content):
    print('----------------------------------------------------')
    print('---------------', entry, '--------------------------')
    print('----------------------------------------------------')
    gitlab_entry = gitlab_content[entry]
    print(gitlab_entry)
    if type(gitlab_entry) is dict:
        if 'allow_failure' in gitlab_entry and gitlab_entry['allow_failure']:
            use_allow_failure_versions = True
        else:
            use_allow_failure_versions = False
        if 'variables' in gitlab_entry:
            variable_list = gitlab_entry['variables']
            print(variable_list)
            if 'PUPPET_VERSION' in variable_list:
                if use_allow_failure_versions:
                    allow_failure_versions.append(variable_list['PUPPET_VERSION'])
                else:
                    versions.append(variable_list['PUPPET_VERSION'])
        if 'script' in gitlab_entry:
            if use_allow_failure_versions:
                allow_failure_versions.extend(__parse_script(gitlab_entry['script']))
            else:
                versions.extend(__parse_script(gitlab_entry['script']))

clean_versions = list(set(versions))
clean_af_versions = list(set(allow_failure_versions))

print(clean_af_versions)
print(clean_versions)

