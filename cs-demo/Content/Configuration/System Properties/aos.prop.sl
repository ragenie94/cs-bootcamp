namespace: ''
properties:
  - script_location: /tmp
  - war_repo_root_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/'
  - ubuntu_vm_username: root
  - ubuntu_vm_password: admin@123
  - script_install_java: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
  - script_install_tomcat: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
  - script_install_postgres: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_postgres.sh'
  - script_deploy_war: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
  - ubuntu_vm_ip: 10.0.46.41
