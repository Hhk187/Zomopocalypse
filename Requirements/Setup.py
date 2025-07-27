import requests, os, json
from zipfile import ZipFile

SetupJson : dict


def LoadSetupJson():
    global SetupJson
    with open(f'{os.curdir}/setup.json', 'r') as f:
        SetupJson = json.load(f)
        print('Setup.json loaded successfully')
        



def DownloadAndInstall(requirement : dict):
    
    for key, value in requirement.items():
        print(f'Downloading {value["name"]}...')
        file = requests.get(value['link'])
        
        with open(f'temp/{value["name"]}.zip', 'wb') as f:
            f.write(file.content)
            
        with ZipFile(f'temp/{value["name"]}.zip', 'r') as zipFile:
            zipFile.extractall(value["location"])

        print(f'{value["name"]} downloaded and installed successfully')
        
        # remove the file from temp
        os.remove(f'temp/{value["name"]}.zip')
    
    
def main():
    LoadSetupJson()
    DownloadAndInstall(SetupJson)
    
if __name__ == '__main__':
    main()