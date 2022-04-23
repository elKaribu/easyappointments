#!/usr/bin/env python

import os
import re
import sys


def main(argv):
    set_timezone()
    init_config(argv[len(argv) - 1])


def set_timezone():
    lines = list()
    with open('/etc/php8/php.ini') as f:
        for line in f.readlines():
            if ';date.timezone' in line:
                lines.append('date.timezone = ' + os.environ['TZ'] + '\n')
            else:
                lines.append(line)
        f.close()
    with open('/etc/php8/php.ini', 'w') as f:
        f.writelines(lines)


def init_config(config_file):
    lines = list()
    with open(config_file) as f:
        for line in f.readlines():
            for match in re.findall(r'\$\{.+\}', line):
                env_name = re.findall(r'(?<=\$\{).+(?=\})', match)[0]
                env = os.environ[env_name] if env_name in os.environ else ''
                if env_name == 'DEBUG_MODE':
                    env = os.environ['DEBUG'] if 'DEBUG' in os.environ else ''
                if env.lower() == 'true' or env.lower() == 'false':
                    env = env.lower()
                line = line.replace(match, env)
            lines.append(line)
        f.close()
    with open(config_file, 'w') as f:
        f.writelines(lines)


main(sys.argv)
