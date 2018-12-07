namespace: demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.41
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/root/target/ROOT.war'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 132
        y: 37
      remote_secure_copy:
        x: 326
        y: 183
        navigate:
          443c5415-0d12-6fec-accf-1fe9737abeac:
            targetId: 1f45ae94-02ab-add9-4d13-25ed164cbb0c
            port: SUCCESS
      get_file:
        x: 126
        y: 187
    results:
      SUCCESS:
        1f45ae94-02ab-add9-4d13-25ed164cbb0c:
          x: 317
          y: 35
