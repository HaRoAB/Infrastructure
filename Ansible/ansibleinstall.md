# Instructions : Ansible

Required:
- Python installed
- Unix-machine (WSL)
- pip || pipx

## Install pipx
```bash
py -3 -m pip install --user pipx
py -3 -m pipx ensurepath
```

## Install ansible
```bash
 # If "No modeule named pip"
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    
python -m pip install --upgrade pip
python -m pip -V 

python -m pip install --user ansible
python -m pip install --upgrade --user ansible

#verify ansible package
ansible-community --version
```


## Adding Ansible command shell completion
```bash
#If you chose the pipx installation instructions:
pipx inject --include-apps ansible argcomplete

#If you chose the pip installation instructions:
python -m pip install --user argcomplete
```

## Configure
```bash
activate-global-python-argcomplete --user
```
