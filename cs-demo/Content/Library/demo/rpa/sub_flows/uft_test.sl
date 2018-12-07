namespace: demo.rpa.sub_flows
flow:
  name: uft_test
  inputs:
    - aos_host: "${get_sp('tomcat_host')}"
    - aos_user: ragenie94
    - aos_password:
        default: Admin@123
        sensitive: false
    - catalog: TABLETS
    - item: HP ELITEPAD 1000 G2 TABLET
    - uft_test_location: "C:\\Users\\Administrator\\Desktop\\AOS_buy_item"
  workflow:
    - run_test:
        do:
          io.cloudslang.microfocus.uft.run_test:
            - host: "${get_sp('uft_host')}"
            - username: "${get_sp('uft_username')}"
            - password:
                value: "${get_sp('uft_password')}"
                sensitive: true
            - port: "${get_sp('uft_port')}"
            - protocol: "${get_sp('uft_protocol')}"
            - is_test_visible: "${get_sp('uft_is_test_visible')}"
            - test_path: '${uft_test_location}'
            - test_results_path: "${get_sp('uft_result_location')}"
            - uft_workspace_path: "${get_sp('uft_result_location')}"
            - test_parameters: "${'host:'+aos_host+',user:'+aos_user+',password:'+aos_password+',catalog:'+catalog+',item:'+item}"
            - operation_timeout: '300'
        publish:
          - test_return_result: '${return_result}'
          - test_return_code: '${return_code}'
          - test_exit_code: '${script_exit_code}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - test_return_result: '${test_return_result}'
    - test_exit_code: '${test_exit_code}'
    - test_return_code: '${test_return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      run_test:
        x: 89
        y: 95
        navigate:
          0c090e1c-9bc7-dd8c-643b-d7e21406e34c:
            targetId: 8615fef6-a9f3-95c4-37d8-3d9f18524dc5
            port: SUCCESS
    results:
      SUCCESS:
        8615fef6-a9f3-95c4-37d8-3d9f18524dc5:
          x: 276
          y: 94
