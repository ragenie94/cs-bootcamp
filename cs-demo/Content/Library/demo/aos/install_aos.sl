namespace: demo.aos
flow:
  name: install_aos
  inputs:
    - account_service_host:
        required: false
    - tomcat_host: "${get_sp('tomcat_host')}"
    - db_host:
        required: false
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
  workflow:
    - install_postgres:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_postgres')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_account_service
    - is_account_service:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(get('account_service_host', tomcat_host) != tomcat_host)}"
        navigate:
          - 'TRUE': install_tomcat_as
          - 'FALSE': deploy_wars
    - install_tomcat_as:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java_as
    - install_java_as:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: "${get_sp('account_service_host')}"
            - username: '${username}'
            - password: '${password}'
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_wars
    - deploy_wars:
        do:
          demo.aos.sub_flows.deploy_wars:
            - tomcat_host: "${get_sp('tomcat_host')}"
            - account_service_host: "${get('account_service_host', tomcat_host)}"
            - db_host: "${get('db_host', tomcat_host)}"
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
            - url: "${get_sp('war_repo_root_url')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 59
        y: 78
      install_java:
        x: 197
        y: 79
      install_tomcat:
        x: 335
        y: 76
      is_account_service:
        x: 261
        y: 197
      install_tomcat_as:
        x: 45
        y: 349
      install_java_as:
        x: 248
        y: 340
      deploy_wars:
        x: 390
        y: 331
        navigate:
          0a069fb5-0fd8-117f-a4b1-e2c1746a5334:
            targetId: bd69e791-f928-2075-24fd-cb2f66fa5ce3
            port: SUCCESS
    results:
      SUCCESS:
        bd69e791-f928-2075-24fd-cb2f66fa5ce3:
          x: 445
          y: 203
