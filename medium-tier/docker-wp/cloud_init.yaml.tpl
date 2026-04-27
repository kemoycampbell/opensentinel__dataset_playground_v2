#cloud-config
package_update: true
packages:
  - docker

write_files:
%{ for file in files ~}
  - path: /home/${file.user}/${file.name}
    permissions: '${file.permissions}'
    owner: ${file.owner}
    content: |
%{ for line in split("\n", file.content) ~}
      ${line}
%{ endfor ~}
%{ endfor ~}


runcmd:
  - sudo service docker start
  - sudo usermod -aG docker ec2-user
  - newgrp docker
%{ for command in commands ~}
  - ${command}
%{ endfor ~}

