
## Useful commands for Ansible
```bash
ansible-playbook
    -i - uses my_inventory_file in the path provided for inventory to match the pattern.
    -u - connects over SSH as my_connection_user.
    -k - asks for password which is then provided to SSH authentication.
    -f - allocates 3 forks.
    -T - sets a 30-second timeout.
    -t - runs only tasks marked with the tag my_tag.
    -M - loads local modules from /path/to/my/modules.
    -b - executes with elevated privileges (uses become).
    -K - prompts the user for the become password.

# run playbook:
ansible-playbook playbook.yml -f 10

# check playbook
ansible-playbook --check playbook.yaml

# nodes check in to a central location, instead of pushing configuration out to them
ansible-pull 

# You may want to verify your playbooks to catch syntax errors and other problems before you run them
ansible-playbook
    --check,
    --diff, 
    --list-hosts, 
    --list-tasks, and 
    --syntax-check.

# You can use ansible-lint for detailed, Ansible-specific feedback on your playbooks before you execute them
ansible-lint


```