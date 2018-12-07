namespace: demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.41
    - username: root
    - password: admin@123
    - filename: ROOT.war
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 86
        y: 88
        navigate:
          6a25670d-f90a-7bb8-e652-f524b717f98f:
            targetId: 0a94b8a4-ff43-ec62-25f5-b802ba565ca2
            port: SUCCESS
    results:
      SUCCESS:
        0a94b8a4-ff43-ec62-25f5-b802ba565ca2:
          x: 260
          y: 93
