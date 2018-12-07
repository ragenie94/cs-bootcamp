namespace: demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: "${get_sp('tomcat_host')}"
    - account_service_host: "${get_sp('account_service_host')}"
    - db_host: "${get_sp('postgres_host')}"
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - script_url: "${get_sp('script_deploy_war')}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 82
        y: 102
      deploy_tm_wars:
        x: 264
        y: 106
        navigate:
          8dcbe0b9-8972-c4a3-0e60-5cb4476e16ef:
            targetId: 6f5e4636-1747-ed2c-e667-dbe0e4e2224f
            port: SUCCESS
    results:
      SUCCESS:
        6f5e4636-1747-ed2c-e667-dbe0e4e2224f:
          x: 450
          y: 110
