#!/bin/bash
echo "Users with /bin/bash shell:"
grep "/bin/bash" /etc/passwd | cut -d: -f1 
