namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: "${get_sp('postgres_host')}"
    - username: "${get_sp('vm_username')}"
    - password:
        default: "${get_sp('vm_password')}"
        sensitive: false
    - artifact_url:
        required: false
    - script_url: "${get_sp('script_install_postgres')}"
    - parameters:
        required: false
  workflow:
    - artifact_url_isEmpty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      artifact_url_isEmpty:
        x: 273
        y: 1
      copy_artifact:
        x: 71
        y: 103
      copy_script:
        x: 389
        y: 93
      execute_script:
        x: 43
        y: 240
      delete_script:
        x: 272
        y: 330
      is_true:
        x: 516
        y: 315
        navigate:
          53a95f64-19b3-b3e0-22b4-94454f3ed7f6:
            targetId: ac5ab8d0-3651-528a-2c00-a9b9a1151d98
            port: 'TRUE'
          19b8f83d-e130-8ac7-be38-3be40e986e5c:
            targetId: a639dfd9-28f6-36d7-e2e6-460b351622be
            port: 'FALSE'
    results:
      FAILURE:
        a639dfd9-28f6-36d7-e2e6-460b351622be:
          x: 669
          y: 376
      SUCCESS:
        ac5ab8d0-3651-528a-2c00-a9b9a1151d98:
          x: 662
          y: 262
