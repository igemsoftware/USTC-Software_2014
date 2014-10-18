from yaml import load

config_file = open('config.yaml')
config = load(config_file)
config_file.close()
