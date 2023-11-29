
## Ensure you have required ansible roles installed
``` bash
ansible-galaxy install azure.azure_preview_modules
ansible-galaxy install geerlingguy.helm
```
## Run playbook
``` bash
ansible-playbook -i localhost, deploy_all.yml --ask-vault-pass

```